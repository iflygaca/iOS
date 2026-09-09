import SwiftUI
import Combine

/// Live & Offline Saudi Civil Aviation METAR Weather Service
@MainActor
final class METARService: ObservableObject {
    static let shared = METARService()

    @Published var airports: [METARReport] = METARService.defaultSaudiAirports
    @Published var isLoading: Bool = false
    @Published var lastUpdated: Date? = nil
    @Published var isOfflineMode: Bool = true
    @Published var lastErrorMessage: String? = nil

    private struct NOAAMetarResponse: Decodable {
        let icaoId: String
        let rawOb: String?
        let temp: Double?
        let dewp: Double?
        let wdir: Int?
        let wspd: Int?
        let wgst: Int?
        let visib: String?
        let altim: Double?
        let fltCat: String?
        let cover: String?
    }

    init() {
        Task {
            await fetchLiveSaudiMETARs()
        }
    }

    // MARK: - Live NOAA Aviation Weather API Fetcher
    func fetchLiveSaudiMETARs() async {
        isLoading = true
        lastErrorMessage = nil

        let icaoList = airports.map { $0.icaoCode }.joined(separator: ",")
        guard let url = URL(string: "https://aviationweather.gov/api/data/metar?ids=\(icaoList)&format=json") else {
            isLoading = false
            return
        }

        do {
            var request = URLRequest(url: url)
            request.timeoutInterval = 9.0
            request.setValue("CaptainAdel-iOS/1.0 (Aviation GACAR Regulatory App)", forHTTPHeaderField: "User-Agent")

            let (data, response) = try await URLSession.shared.data(for: request)

            guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
                throw URLError(.badServerResponse)
            }

            let decodedList = try JSONDecoder().decode([NOAAMetarResponse].self, from: data)
            let reportsByICAO = Dictionary(uniqueKeysWithValues: decodedList.map { ($0.icaoId.uppercased(), $0) })

            var updatedAirports: [METARReport] = []
            let now = Date()

            for airport in airports {
                if let live = reportsByICAO[airport.icaoCode.uppercased()] {
                    var updated = airport
                    if let raw = live.rawOb, !raw.isEmpty {
                        updated = METARReport(
                            rawText: raw,
                            icaoCode: airport.icaoCode,
                            airportNameEn: airport.airportNameEn,
                            airportNameAr: airport.airportNameAr,
                            flightCategory: parseFlightCategory(live.fltCat),
                            windInfo: formatWind(dir: live.wdir, speed: live.wspd, gust: live.wgst),
                            visibility: formatVisibility(live.visib),
                            ceiling: live.cover ?? airport.ceiling,
                            temperature: formatTemp(live.temp),
                            dewPoint: formatTemp(live.dewp),
                            altimeter: formatAltimeter(live.altim),
                            remarks: "Live NOAA Station Report",
                            isLive: true,
                            lastUpdated: now
                        )
                    }
                    updatedAirports.append(updated)
                } else {
                    updatedAirports.append(airport)
                }
            }

            self.airports = updatedAirports
            self.lastUpdated = now
            self.isOfflineMode = false
            self.isLoading = false
        } catch {
            self.isOfflineMode = true
            self.lastErrorMessage = error.localizedDescription
            self.isLoading = false
        }
    }

    // MARK: - Formatters
    private func parseFlightCategory(_ cat: String?) -> FlightCategory {
        switch cat?.uppercased() {
        case "VFR": return .vfr
        case "MVFR": return .mvfr
        case "IFR": return .ifr
        case "LIFR": return .lifr
        default: return .vfr
        }
    }

    private func formatWind(dir: Int?, speed: Int?, gust: Int?) -> String {
        guard let dir = dir, let speed = speed else { return "Calm / Variable" }
        if let gust = gust, gust > speed {
            return String(format: "%03d° at %d knots, gusts %d kt", dir, speed, gust)
        }
        return String(format: "%03d° at %d knots", dir, speed)
    }

    private func formatVisibility(_ vis: String?) -> String {
        guard let vis = vis else { return "10+ km (CAVOK)" }
        if vis.contains("+") {
            return "10+ km (6+ SM)"
        }
        return "\(vis) statute miles"
    }

    private func formatTemp(_ val: Double?) -> String {
        guard let c = val else { return "N/A" }
        let f = Int(round((c * 9.0 / 5.0) + 32.0))
        return String(format: "%.0f°C (%d°F)", c, f)
    }

    private func formatAltimeter(_ val: Double?) -> String {
        guard let qnh = val else { return "1013 hPa / 29.92 inHg" }
        let inHg = qnh * 0.02953
        return String(format: "%.0f hPa / %.2f inHg", qnh, inHg)
    }

    // MARK: - Calculations
    static func calculateCrosswind(windSpeed: Double, windDirection: Double, runwayHeading: Double) -> (crosswind: Double, headwind: Double) {
        let angleDegrees = abs(windDirection - runwayHeading)
        let angleRadians = angleDegrees * .pi / 180.0
        let crosswind = abs(windSpeed * sin(angleRadians))
        let headwind = windSpeed * cos(angleRadians)
        return (crosswind, headwind)
    }

    // MARK: - Complete 26-Airport Saudi Aerodrome Database (Offline Baseline)
    static let defaultSaudiAirports: [METARReport] = [
        METARReport(
            rawText: "OERK 080800Z 18010KT CAVOK 41/04 Q1011 NOSIG",
            icaoCode: "OERK",
            airportNameEn: "King Khalid Int'l (Riyadh)",
            airportNameAr: "مطار الملك خالد الدولي (الرياض)",
            flightCategory: .vfr,
            windInfo: "180° at 10 knots",
            visibility: "10+ km (CAVOK)",
            ceiling: "Clear / Sky Clear",
            temperature: "41°C (106°F)",
            dewPoint: "04°C (39°F)",
            altimeter: "1011 hPa / 29.85 inHg",
            remarks: "Major HUB · RWY 15L/33R & 15R/33L",
            isLive: false,
            lastUpdated: nil
        ),
        METARReport(
            rawText: "OEJN 080800Z 25004KT 9999 FEW040 37/23 Q1007 NOSIG",
            icaoCode: "OEJN",
            airportNameEn: "King Abdulaziz Int'l (Jeddah)",
            airportNameAr: "مطار الملك عبدالعزيز الدولي (جدة)",
            flightCategory: .vfr,
            windInfo: "250° at 4 knots",
            visibility: "10+ km",
            ceiling: "Few clouds at 4,000 ft",
            temperature: "37°C (99°F)",
            dewPoint: "23°C (73°F)",
            altimeter: "1007 hPa / 29.74 inHg",
            remarks: "Coastal station · RWY 34L/16R & 34C/16C",
            isLive: false,
            lastUpdated: nil
        ),
        METARReport(
            rawText: "OEDF 080800Z 23015KT CAVOK 46/12 Q1004 NOSIG",
            icaoCode: "OEDF",
            airportNameEn: "King Fahd Int'l (Dammam)",
            airportNameAr: "مطار الملك فهد الدولي (الدمام)",
            flightCategory: .vfr,
            windInfo: "230° at 15 knots",
            visibility: "10+ km (CAVOK)",
            ceiling: "Clear",
            temperature: "46°C (115°F)",
            dewPoint: "12°C (54°F)",
            altimeter: "1004 hPa / 29.65 inHg",
            remarks: "Eastern province hub · RWY 16L/34R",
            isLive: false,
            lastUpdated: nil
        ),
        METARReport(
            rawText: "OEMA 080800Z 21005KT CAVOK 40/02 Q1011 NOSIG",
            icaoCode: "OEMA",
            airportNameEn: "Prince Mohammad Int'l (Madinah)",
            airportNameAr: "مطار الأمير محمد بن عبدالعزيز (المدينة)",
            flightCategory: .vfr,
            windInfo: "210° at 5 knots",
            visibility: "10+ km (CAVOK)",
            ceiling: "Clear",
            temperature: "40°C (104°F)",
            dewPoint: "02°C (36°F)",
            altimeter: "1011 hPa / 29.85 inHg",
            remarks: "Holy city airport · RWY 17/35",
            isLive: false,
            lastUpdated: nil
        ),
        METARReport(
            rawText: "OERS 080800Z 32014KT CAVOK 34/22 Q1008 NOSIG",
            icaoCode: "OERS",
            airportNameEn: "Red Sea International (Hanak)",
            airportNameAr: "مطار البحر الأحمر الدولي (حنك)",
            flightCategory: .vfr,
            windInfo: "320° at 14 knots",
            visibility: "10+ km (CAVOK)",
            ceiling: "Clear",
            temperature: "34°C (93°F)",
            dewPoint: "22°C (72°F)",
            altimeter: "1008 hPa / 29.77 inHg",
            remarks: "Sustainable architectural hub · RWY 15/33",
            isLive: false,
            lastUpdated: nil
        ),
        METARReport(
            rawText: "OENN 080800Z 35012KT CAVOK 33/19 Q1010 NOSIG",
            icaoCode: "OENN",
            airportNameEn: "NEOM Bay Airport (Sharma)",
            airportNameAr: "مطار خليج نيوم (شرما)",
            flightCategory: .vfr,
            windInfo: "350° at 12 knots",
            visibility: "10+ km (CAVOK)",
            ceiling: "Clear",
            temperature: "33°C (91°F)",
            dewPoint: "19°C (66°F)",
            altimeter: "1010 hPa / 29.83 inHg",
            remarks: "Northern Red Sea Megaproject · RWY 15/33",
            isLive: false,
            lastUpdated: nil
        ),
        METARReport(
            rawText: "OEAB 080800Z 31008KT CAVOK 29/M04 Q1025 NOSIG",
            icaoCode: "OEAB",
            airportNameEn: "Abha Regional Airport (Abha)",
            airportNameAr: "مطار أبها الدولي (أبها)",
            flightCategory: .vfr,
            windInfo: "310° at 8 knots",
            visibility: "10+ km (CAVOK)",
            ceiling: "Clear",
            temperature: "29°C (84°F)",
            dewPoint: "-04°C (25°F)",
            altimeter: "1025 hPa / 30.27 inHg",
            remarks: "High elevation aerodrome (6,858 ft MSL) · RWY 13/31",
            isLive: false,
            lastUpdated: nil
        ),
        METARReport(
            rawText: "OEAO 080800Z 36006KT CAVOK 39/01 Q1013 NOSIG",
            icaoCode: "OEAO",
            airportNameEn: "Prince Abdul Majeed (Al Ula)",
            airportNameAr: "مطار الأمير عبدالمجيد (العلا)",
            flightCategory: .vfr,
            windInfo: "360° at 6 knots",
            visibility: "10+ km",
            ceiling: "Clear",
            temperature: "39°C (102°F)",
            dewPoint: "01°C (34°F)",
            altimeter: "1013 hPa / 29.91 inHg",
            remarks: "Desert valley terrain · RWY 12/30",
            isLive: false,
            lastUpdated: nil
        ),
        METARReport(
            rawText: "OETB 080800Z 02008KT CAVOK 38/03 Q1014 NOSIG",
            icaoCode: "OETB",
            airportNameEn: "Prince Sultan Bin Abdulaziz (Tabuk)",
            airportNameAr: "مطار الأمير سلطان بن عبدالعزيز (تبوك)",
            flightCategory: .vfr,
            windInfo: "020° at 8 knots",
            visibility: "10+ km",
            ceiling: "Clear",
            temperature: "38°C (100°F)",
            dewPoint: "03°C (37°F)",
            altimeter: "1014 hPa / 29.94 inHg",
            remarks: "Northern border region · RWY 05/23",
            isLive: false,
            lastUpdated: nil
        ),
        METARReport(
            rawText: "OETR 080800Z 11009KT CAVOK 31/06 Q1020 NOSIG",
            icaoCode: "OETR",
            airportNameEn: "Taif Regional Airport (Taif)",
            airportNameAr: "مطار الطائف الدولي (الطائف)",
            flightCategory: .vfr,
            windInfo: "110° at 9 knots",
            visibility: "10+ km",
            ceiling: "Clear",
            temperature: "31°C (88°F)",
            dewPoint: "06°C (43°F)",
            altimeter: "1020 hPa / 30.12 inHg",
            remarks: "Mountain plateaus (4,783 ft MSL) · RWY 02/20",
            isLive: false,
            lastUpdated: nil
        ),
        METARReport(
            rawText: "OEGS 080800Z 15007KT CAVOK 42/05 Q1012 NOSIG",
            icaoCode: "OEGS",
            airportNameEn: "Prince Naif Bin Abdulaziz (Qassim)",
            airportNameAr: "مطار الأمير نايف بن عبدالعزيز (القصيم)",
            flightCategory: .vfr,
            windInfo: "150° at 7 knots",
            visibility: "10+ km",
            ceiling: "Clear",
            temperature: "42°C (108°F)",
            dewPoint: "05°C (41°F)",
            altimeter: "1012 hPa / 29.88 inHg",
            remarks: "Central region hub · RWY 15/33",
            isLive: false,
            lastUpdated: nil
        ),
        METARReport(
            rawText: "OEYN 080800Z 28012KT CAVOK 36/20 Q1008 NOSIG",
            icaoCode: "OEYN",
            airportNameEn: "Prince Abdul Mohsin (Yanbu)",
            airportNameAr: "مطار الأمير عبدالمحسن (ينبع)",
            flightCategory: .vfr,
            windInfo: "280° at 12 knots",
            visibility: "10+ km",
            ceiling: "Clear",
            temperature: "36°C (97°F)",
            dewPoint: "20°C (68°F)",
            altimeter: "1008 hPa / 29.77 inHg",
            remarks: "Red Sea coastal port · RWY 10/28",
            isLive: false,
            lastUpdated: nil
        ),
        METARReport(
            rawText: "OEGN 080800Z 24009KT 8000 HZ FEW025 35/27 Q1009",
            icaoCode: "OEGN",
            airportNameEn: "King Abdullah Airport (Jazan)",
            airportNameAr: "مطار الملك عبدالله (جازان)",
            flightCategory: .mvfr,
            windInfo: "240° at 9 knots",
            visibility: "8,000 m (Haze)",
            ceiling: "Few clouds at 2,500 ft",
            temperature: "35°C (95°F)",
            dewPoint: "27°C (81°F)",
            altimeter: "1009 hPa / 29.80 inHg",
            remarks: "Southern Red Sea coastal corridor · RWY 15/33",
            isLive: false,
            lastUpdated: nil
        ),
        METARReport(
            rawText: "OEAH 080800Z 21010KT CAVOK 45/09 Q1006 NOSIG",
            icaoCode: "OEAH",
            airportNameEn: "Al-Ahsa International (Al-Ahsa)",
            airportNameAr: "مطار الأحساء الدولي (الأحساء)",
            flightCategory: .vfr,
            windInfo: "210° at 10 knots",
            visibility: "10+ km",
            ceiling: "Clear",
            temperature: "45°C (113°F)",
            dewPoint: "09°C (48°F)",
            altimeter: "1006 hPa / 29.71 inHg",
            remarks: "Oasis basin airfield · RWY 16/34",
            isLive: false,
            lastUpdated: nil
        ),
        METARReport(
            rawText: "OEBA 080800Z 34007KT CAVOK 28/05 Q1024 NOSIG",
            icaoCode: "OEBA",
            airportNameEn: "King Saud Airport (Al Baha)",
            airportNameAr: "مطار الملك سعود (الباحة)",
            flightCategory: .vfr,
            windInfo: "340° at 7 knots",
            visibility: "10+ km",
            ceiling: "Clear",
            temperature: "28°C (82°F)",
            dewPoint: "05°C (41°F)",
            altimeter: "1024 hPa / 30.24 inHg",
            remarks: "Mountainous airfield elevation 5,550 ft MSL · RWY 17/35",
            isLive: false,
            lastUpdated: nil
        ),
        METARReport(
            rawText: "OEHL 080800Z 16008KT CAVOK 39/02 Q1013 NOSIG",
            icaoCode: "OEHL",
            airportNameEn: "Hail Regional Airport (Hail)",
            airportNameAr: "مطار حائل الدولي (حائل)",
            flightCategory: .vfr,
            windInfo: "160° at 8 knots",
            visibility: "10+ km",
            ceiling: "Clear",
            temperature: "39°C (102°F)",
            dewPoint: "02°C (36°F)",
            altimeter: "1013 hPa / 29.91 inHg",
            remarks: "Northern highlands airfield · RWY 18/36",
            isLive: false,
            lastUpdated: nil
        ),
        METARReport(
            rawText: "OENG 080800Z 20006KT CAVOK 33/08 Q1021 NOSIG",
            icaoCode: "OENG",
            airportNameEn: "Najran Domestic Airport (Najran)",
            airportNameAr: "مطار نجران الإقليمي (نجران)",
            flightCategory: .vfr,
            windInfo: "200° at 6 knots",
            visibility: "10+ km",
            ceiling: "Clear",
            temperature: "33°C (91°F)",
            dewPoint: "08°C (46°F)",
            altimeter: "1021 hPa / 30.15 inHg",
            remarks: "Southern border valley · RWY 06/24",
            isLive: false,
            lastUpdated: nil
        ),
        METARReport(
            rawText: "OEWD 080800Z 17009KT CAVOK 42/06 Q1012 NOSIG",
            icaoCode: "OEWD",
            airportNameEn: "Wadi Al Dawasir Airport",
            airportNameAr: "مطار وادي الدواسر المحلي",
            flightCategory: .vfr,
            windInfo: "170° at 9 knots",
            visibility: "10+ km",
            ceiling: "Clear",
            temperature: "42°C (108°F)",
            dewPoint: "06°C (43°F)",
            altimeter: "1012 hPa / 29.88 inHg",
            remarks: "Southern desert corridor · RWY 10/28",
            isLive: false,
            lastUpdated: nil
        ),
        METARReport(
            rawText: "OESH 080800Z 18008KT CAVOK 37/09 Q1017 NOSIG",
            icaoCode: "OESH",
            airportNameEn: "Sharurah Domestic Airport",
            airportNameAr: "مطار شرورة المحلي",
            flightCategory: .vfr,
            windInfo: "180° at 8 knots",
            visibility: "10+ km",
            ceiling: "Clear",
            temperature: "37°C (99°F)",
            dewPoint: "09°C (48°F)",
            altimeter: "1017 hPa / 30.03 inHg",
            remarks: "Empty Quarter border post · RWY 08/26",
            isLive: false,
            lastUpdated: nil
        ),
        METARReport(
            rawText: "OERF 080800Z 12007KT CAVOK 39/04 Q1014 NOSIG",
            icaoCode: "OERF",
            airportNameEn: "Rafha Domestic Airport",
            airportNameAr: "مطار رفحاء المحلي",
            flightCategory: .vfr,
            windInfo: "120° at 7 knots",
            visibility: "10+ km",
            ceiling: "Clear",
            temperature: "39°C (102°F)",
            dewPoint: "04°C (39°F)",
            altimeter: "1014 hPa / 29.94 inHg",
            remarks: "Northern border outpost · RWY 11/29",
            isLive: false,
            lastUpdated: nil
        ),
        METARReport(
            rawText: "OEBH 080800Z 20008KT CAVOK 32/06 Q1018 NOSIG",
            icaoCode: "OEBH",
            airportNameEn: "Bisha Domestic Airport",
            airportNameAr: "مطار بيشة المحلي",
            flightCategory: .vfr,
            windInfo: "200° at 8 knots",
            visibility: "10+ km (CAVOK)",
            ceiling: "Clear",
            temperature: "32°C (90°F)",
            dewPoint: "06°C (43°F)",
            altimeter: "1018 hPa / 30.06 inHg",
            remarks: "Asir plateau crossroads · RWY 18/36",
            isLive: false,
            lastUpdated: nil
        ),
        METARReport(
            rawText: "OERR 080800Z 08010KT CAVOK 36/05 Q1015 NOSIG",
            icaoCode: "OERR",
            airportNameEn: "Arar Domestic Airport",
            airportNameAr: "مطار عرعر المحلي",
            flightCategory: .vfr,
            windInfo: "080° at 10 knots",
            visibility: "10+ km (CAVOK)",
            ceiling: "Clear",
            temperature: "36°C (97°F)",
            dewPoint: "05°C (41°F)",
            altimeter: "1015 hPa / 29.97 inHg",
            remarks: "Northern frontier capital · RWY 10/28",
            isLive: false,
            lastUpdated: nil
        ),
        METARReport(
            rawText: "OEDM 080800Z 14006KT CAVOK 43/03 Q1012 NOSIG",
            icaoCode: "OEDM",
            airportNameEn: "Dawadmi Domestic Airport",
            airportNameAr: "مطار الدوادمي المحلي",
            flightCategory: .vfr,
            windInfo: "140° at 6 knots",
            visibility: "10+ km (CAVOK)",
            ceiling: "Clear",
            temperature: "43°C (109°F)",
            dewPoint: "03°C (37°F)",
            altimeter: "1012 hPa / 29.88 inHg",
            remarks: "Najd plains aerodrome · RWY 15/33",
            isLive: false,
            lastUpdated: nil
        ),
        METARReport(
            rawText: "OEWJ 080800Z 30012KT CAVOK 35/21 Q1009 NOSIG",
            icaoCode: "OEWJ",
            airportNameEn: "Al Wajh Domestic Airport",
            airportNameAr: "مطار الوجه المحلي",
            flightCategory: .vfr,
            windInfo: "300° at 12 knots",
            visibility: "10+ km (CAVOK)",
            ceiling: "Clear",
            temperature: "35°C (95°F)",
            dewPoint: "21°C (70°F)",
            altimeter: "1009 hPa / 29.80 inHg",
            remarks: "Red Sea coast gateway · RWY 15/33",
            isLive: false,
            lastUpdated: nil
        ),
        METARReport(
            rawText: "OEGT 080800Z 06008KT CAVOK 37/04 Q1014 NOSIG",
            icaoCode: "OEGT",
            airportNameEn: "Gurayat Domestic Airport",
            airportNameAr: "مطار القريات المحلي",
            flightCategory: .vfr,
            windInfo: "060° at 8 knots",
            visibility: "10+ km (CAVOK)",
            ceiling: "Clear",
            temperature: "37°C (99°F)",
            dewPoint: "04°C (39°F)",
            altimeter: "1014 hPa / 29.94 inHg",
            remarks: "Northwestern border station · RWY 10/28",
            isLive: false,
            lastUpdated: nil
        ),
        METARReport(
            rawText: "OETR 080800Z 04007KT CAVOK 35/05 Q1015 NOSIG",
            icaoCode: "OETR_TURAIF",
            airportNameEn: "Turaif Domestic Airport",
            airportNameAr: "مطار طريف المحلي",
            flightCategory: .vfr,
            windInfo: "040° at 7 knots",
            visibility: "10+ km (CAVOK)",
            ceiling: "Clear",
            temperature: "35°C (95°F)",
            dewPoint: "05°C (41°F)",
            altimeter: "1015 hPa / 29.97 inHg",
            remarks: "Extreme northern outpost (2,803 ft MSL) · RWY 10/28",
            isLive: false,
            lastUpdated: nil
        )
    ]
}
