CREATE OR REPLACE TABLE `telco-490702.telco.feature_mart` AS
SELECT
  CustomerID,

  -- Demographics
  Gender,
  Age,
  SeniorCitizen,
  Married,
  Dependents,

  -- Services
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

  -- Status
  SatisfactionScore,
  CustomerStatus,
  ChurnLabel,
  ChurnValue,
  ChurnScore,
  CLTV,
  ChurnCategory,
  ChurnReason,

  -- Location
  Country,
  State,
  City,
  ZipCode,
  Latitude,
  Longitude,
  Population,

  -- 1. 가입기간 연 단위 그룹
  FLOOR(TenureInMonths / 12) AS TenureYearGroup,

  -- 2. 가입기간 구간화
  CASE
    WHEN TenureInMonths < 6 THEN '0-5m'
    WHEN TenureInMonths < 12 THEN '6-11m'
    WHEN TenureInMonths < 24 THEN '12-23m'
    WHEN TenureInMonths < 36 THEN '24-35m'
    WHEN TenureInMonths < 48 THEN '36-47m'
    ELSE '48m+'
  END AS TenureBand,

  -- 3. 장기 고객 여부
  CASE
    WHEN TenureInMonths >= 24 THEN 1 ELSE 0
  END AS IsLongTermCustomer,

  -- 4. 고령 고객 여부
  CASE
    WHEN Age >= 60 THEN 1 ELSE 0
  END AS IsSeniorAgeGroup,

  -- 5. 월 요금 대비 누적 요금 비율
  CASE
    WHEN MonthlyCharge > 0 THEN ROUND(TotalCharges / MonthlyCharge, 2)
    ELSE NULL
  END AS ChargeToMonthlyRatio,

  -- 6. 가입기간 기준 월평균 누적 과금
  CASE
    WHEN TenureInMonths > 0 THEN ROUND(TotalCharges / TenureInMonths, 2)
    ELSE NULL
  END AS AvgChargePerMonth,

  -- 7. 고객 생애가치 대비 누적매출 비율
  CASE
    WHEN CLTV > 0 THEN ROUND(TotalRevenue / CLTV, 4)
    ELSE NULL
  END AS RevenueToCltvRatio,

  -- 8. 월 요금 수준 구간화
  CASE
    WHEN MonthlyCharge < 30 THEN 'Low'
    WHEN MonthlyCharge < 70 THEN 'Mid'
    ELSE 'High'
  END AS MonthlyChargeBand,

  -- 9. 만족도 구간화
  CASE
    WHEN SatisfactionScore >= 4 THEN 'High'
    WHEN SatisfactionScore = 3 THEN 'Mid'
    ELSE 'Low'
  END AS SatisfactionBand,

  -- 10. 지역 인구 규모 구간화
  CASE
    WHEN Population >= 100000 THEN 'High'
    WHEN Population >= 50000 THEN 'Mid'
    ELSE 'Low'
  END AS PopulationBand,

  -- 11. 계약 리스크 수준
  CASE
    WHEN Contract = 'Month-to-Month' THEN 'High Risk'
    WHEN Contract = 'One Year' THEN 'Medium Risk'
    WHEN Contract = 'Two Year' THEN 'Low Risk'
    ELSE 'Unknown'
  END AS ContractRiskLevel,

  -- 12. 전자결제/자동이체 계열 여부 예시
  CASE
    WHEN LOWER(PaymentMethod) LIKE '%automatic%' THEN 1
    ELSE 0
  END AS IsAutoPayment

FROM `telco-490702.telco.analysis_base`;
