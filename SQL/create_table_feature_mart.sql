-- ================================================================
-- feature_mart 테이블 생성
-- 목적: analysis_base를 기반으로 모델링에 필요한 파생변수를 추가해
--       머신러닝 입력용 피처 마트 구성
-- ================================================================
CREATE OR REPLACE TABLE `telco-490702.telco.feature_mart` AS
SELECT
  CustomerID,

  -- ── 인구통계 (Demographics) ───────────────────────────────
  Gender,
  Age,
  SeniorCitizen,
  Married,
  Dependents,

  -- ── 서비스 이용 정보 (Services) ───────────────────────────
  TenureInMonths,
  Offer,
  PhoneService,
  InternetService,
  InternetType,
  Contract,
  PaymentMethod,
  MonthlyCharge,
  TotalCharges,
  TotalRevenue,

  -- ── 고객 상태 정보 (Status) ───────────────────────────────
  SatisfactionScore,
  CustomerStatus,
  ChurnLabel,
  ChurnValue,   -- 모델 타깃 변수 (1: 이탈 / 0: 유지)
  ChurnScore,
  CLTV,
  ChurnCategory,
  ChurnReason,

  -- ── 지역 정보 (Location) ──────────────────────────────────
  Country,
  State,
  City,
  ZipCode,
  Latitude,
  Longitude,
  Population,

  -- ================================================================
  -- 파생변수 (Feature Engineering)
  -- ================================================================

  -- 1. 가입기간 연 단위 그룹
  --    예) 14개월 → 1 (1년차), 25개월 → 2 (2년차)
  FLOOR(TenureInMonths / 12) AS TenureYearGroup,

  -- 2. 가입기간 구간화
  --    모델에서 범주형으로 활용하기 위해 6단계 구간으로 분류
  CASE
    WHEN TenureInMonths < 6  THEN '0-5m'
    WHEN TenureInMonths < 12 THEN '6-11m'
    WHEN TenureInMonths < 24 THEN '12-23m'
    WHEN TenureInMonths < 36 THEN '24-35m'
    WHEN TenureInMonths < 48 THEN '36-47m'
    ELSE '48m+'
  END AS TenureBand,

  -- 3. 장기 고객 여부 (가입 24개월 이상이면 1)
  CASE
    WHEN TenureInMonths >= 24 THEN 1 ELSE 0
  END AS IsLongTermCustomer,

  -- 4. 고령 고객 여부 (60세 이상이면 1)
  CASE
    WHEN Age >= 60 THEN 1 ELSE 0
  END AS IsSeniorAgeGroup,

  -- 5. 월 요금 대비 누적 요금 비율
  --    값이 클수록 장기 가입 고객 / 관계가 충분히 쌓인 고객을 의미
  --    MonthlyCharge가 0이면 NULL 처리 (ZeroDivision 방지)
  CASE
    WHEN MonthlyCharge > 0 THEN ROUND(TotalCharges / MonthlyCharge, 2)
    ELSE NULL
  END AS ChargeToMonthlyRatio,

  -- 6. 가입기간 기준 월평균 누적 과금
  --    TotalCharges를 TenureInMonths로 나눠 실제 월 부담 수준 측정
  --    TenureInMonths가 0이면 NULL 처리 (ZeroDivision 방지)
  CASE
    WHEN TenureInMonths > 0 THEN ROUND(TotalCharges / TenureInMonths, 2)
    ELSE NULL
  END AS AvgChargePerMont