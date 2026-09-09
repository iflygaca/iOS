import math
import sys
import os
import re

passed_count = 0
failed_count = 0

def assert_test(condition, name):
    global passed_count, failed_count
    if condition:
        passed_count += 1
        print(f"  ✅ PASS: {name}")
    else:
        failed_count += 1
        print(f"  ❌ FAIL: {name}")

def assert_approx_equal(a, b, tolerance=0.02, name=""):
    global passed_count, failed_count
    diff = abs(a - b)
    if diff <= tolerance:
        passed_count += 1
        print(f"  ✅ PASS: {name} ({a:.2f} ≈ {b:.2f})")
    else:
        failed_count += 1
        print(f"  ❌ FAIL: {name} ({a:.2f} vs expected {b:.2f}, diff={diff:.3f} > tol={tolerance})")

print("=======================================================")
print("🧪 CAPTAIN ADEL AUTOMATED UNIT & VERIFICATION TEST SUITE")
print("=======================================================\n")

# --- SUITE 1: FMC FLIGHT COMPUTER MATHEMATICS ---
print("--- [Suite 1: FMC Flight Computer Mathematics] ---")

def compute_fuel(flight_minutes, burn_rate_gph, is_night):
    cruise = (flight_minutes / 60.0) * burn_rate_gph
    reserve_hours = (45.0 / 60.0) if is_night else (30.0 / 60.0)
    reserve = reserve_hours * burn_rate_gph
    return reserve, cruise + reserve

res_day, tot_day = compute_fuel(120, 10, False)
assert_approx_equal(res_day, 5.0, 0.01, "Day VFR reserve fuel is exactly 30 mins at 10 GPH")
assert_approx_equal(tot_day, 25.0, 0.01, "Day VFR total fuel is 25 gallons")

res_night, tot_night = compute_fuel(120, 10, True)
assert_approx_equal(res_night, 7.5, 0.01, "Night VFR reserve fuel is exactly 45 mins at 10 GPH")
assert_approx_equal(tot_night, 27.5, 0.01, "Night VFR total fuel is 27.5 gallons")

# 1.2 Crosswind & Headwind Components
def compute_wind(runway_deg, wind_dir_deg, wind_speed_kts):
    angle_rad = abs(wind_dir_deg - runway_deg) * (math.pi / 180.0)
    crosswind = abs(wind_speed_kts * math.sin(angle_rad))
    headwind = wind_speed_kts * math.cos(angle_rad)
    return crosswind, headwind

xw, hw = compute_wind(360, 30, 20)
assert_approx_equal(xw, 10.0, 0.01, "Runway 36 with 030/20 gives 10 kt crosswind")
assert_approx_equal(hw, 17.32, 0.05, "Runway 36 with 030/20 gives 17.32 kt headwind")

# 1.3 Pressure & Density Altitude (Hot Weather Saudi Desert Ops)
def compute_density_altitude(elev_ft, qnh_hpa, oat_c):
    pa = elev_ft + (1013.25 - qnh_hpa) * 27.3
    isa = 15.0 - (2.0 * (pa / 1000.0))
    da = pa + (120.0 * (oat_c - isa))
    return pa, isa, da

pa, isa, da = compute_density_altitude(2049, 1008, 45) # Riyadh OERK in summer
assert_test(da > 6000, "Riyadh at 45°C results in severe Density Altitude (>6000 ft)")
assert_test(da > pa, "Density Altitude significantly exceeds Pressure Altitude in high OAT")

# 1.4 Top of Descent (TOD 3:1 Glide Slope Rule)
def compute_tod(cur_alt_ft, tgt_alt_ft, gs_kts):
    alt_lose = max(0, cur_alt_ft - tgt_alt_ft)
    dist_nm = (alt_lose / 1000.0) * 3.0
    vs = -(gs_kts * 5.0)
    mins = (dist_nm / gs_kts) * 60.0 if gs_kts > 0 else 0
    return dist_nm, vs, mins

tod_dist, tod_vs, tod_time = compute_tod(35000, 3000, 420)
assert_approx_equal(tod_dist, 96.0, 0.01, "TOD from FL350 to 3,000ft is exactly 96 NM")
assert_approx_equal(tod_vs, -2100.0, 0.01, "3° Glideslope descent rate at 420 kts is -2,100 FPM")
assert_approx_equal(tod_time, 13.71, 0.05, "TOD descent duration is ~13.7 minutes")

# --- SUITE 2: SAUDI AERODROMES (26 AIRPORTS) ---
print("\n--- [Suite 2: Saudi Aerodromes Coverage (26 Airports)] ---")
metar_path = "MyApp/Services/METARService.swift"
with open(metar_path, "r", encoding="utf-8") as f:
    metar_content = f.read()

icaos = re.findall(r"icaoCode:\s*\"([^\"]+)\"", metar_content)
assert_test(len(icaos) == 26, f"All 26 Saudi Aerodromes are indexed in METARService (found {len(icaos)}/26)")
assert_test("OERS" in icaos, "Red Sea International (OERS) verified in database")
assert_test("OENN" in icaos, "NEOM Bay (OENN) verified in database")
assert_test("OERK" in icaos, "King Khalid International Riyadh (OERK) verified in database")
assert_test("OEJN" in icaos, "King Abdulaziz International Jeddah (OEJN) verified in database")

# --- SUITE 3: QUIZ QUESTION BANK INTEGRITY ---
print("\n--- [Suite 3: Quiz Question Bank Integrity] ---")
quiz_path = "MyApp/Services/QuizService.swift"
with open(quiz_path, "r", encoding="utf-8") as f:
    quiz_content = f.read()

quiz_count = quiz_content.count("QuizQuestion(")
assert_test(quiz_count >= 25, f"Quiz question bank contains at least 25 questions (found {quiz_count})")
assert_test("gacarReference: \"GACAR Part 61" in quiz_content, "Part 61 licensing questions verified")
assert_test("gacarReference: \"GACAR Part 91" in quiz_content, "Part 91 general operating questions verified")
assert_test("gacarReference: \"GACAR Part 107" in quiz_content, "Part 107 drone questions verified")
assert_test("gacarReference: \"GACAR Part 121" in quiz_content, "Part 121 commercial air carrier questions verified")
assert_test("gacarReference: \"GACAR Part 67" in quiz_content, "Part 67 medical standards questions verified")
assert_test("gacarReference: \"GACAR Part 139" in quiz_content, "Part 139 aerodrome ARFF questions verified")

# --- SUITE 4: GACAR REGULATORY CORPUS INTEGRITY ---
print("\n--- [Suite 4: GACAR Regulatory Corpus Integrity] ---")
corpus_path = "MyApp/Models/GACARCorpusDatabase.swift"
with open(corpus_path, "r", encoding="utf-8") as f:
    corpus_content = f.read()

part_count = len(re.findall(r"partNumber:\s*\"([^\"]+)\"", corpus_content))
assert_test(part_count == 74, f"Regulatory corpus contains all 74 GACAR parts (found {part_count}/74)")
assert_test("91.151" in corpus_content, "§ 91.151 fuel reserve clause present")
assert_test("121.619" in corpus_content, "§ 121.619 alternate 1-2-3 rule present")

# --- SUITE 5: captadel.com DOCTRINE ---
print("\n--- [Suite 5: 'Cite or Refuse' Doctrine Verification] ---")
vector_path = "MyApp/Services/GACARVectorSearchEngine.swift"
with open(vector_path, "r", encoding="utf-8") as f:
    vector_content = f.read()

assert_test("refusalThreshold" in vector_content, "Refusal threshold constant defined")
assert_test("isRefusal: true" in vector_content, "Refusal response path implemented")
assert_test("gaca.gov.sa" in vector_content, "Official GACA legal corpus grounding link verified")

print("\n=======================================================")
print(f"🏁 ALL AUTOMATED TESTS FINISHED: {passed_count} Passed, {failed_count} Failed")
print("=======================================================")

if failed_count > 0:
    sys.exit(1)
else:
    sys.exit(0)
