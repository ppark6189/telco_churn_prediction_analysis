-- ================================================================
-- 계약 형태(Contract)별 고객 수 및 이탈률 분석
-- 목적: 계약 유형이 이탈에 미치는 영향 파악
-- ================================================================
SELECT
  Contract,                                              -- 계약 형태 (Month-to-Month / One Year / Two Year)
  COUNT(*) AS customer_cnt,                              -- 전체 고객 수
  SUM(ChurnValue) AS churn_cnt,                         -- 이탈 고객 수 (ChurnValue = 1인 경우)
  ROUND(SAFE_DIVIDE(SUM(ChurnValue), COUNT(*)), 4) AS churn_rate  -- 이탈률 (분모 0 방지를 위해 SAFE_DIVIDE 사용)
FROM `telco-490702.telco.feature_mart`
GROUP BY Contract
ORDER BY churn_rate DESC;                               -- 이탈률 높은 순 정렬


-- ================================================================
-- 인터넷 유형(InternetType)별 고객 수 및 이탈률 분석
-- 목적: 인터넷 서비스 종류가 이탈에 미치는 영향 파악
-- ================================================================
SELECT
  InternetType,                                          -- 인터넷 유형 (Fiber Optic / DSL / Cable / None)
  COUNT(*) AS customer_cnt,                              -- 전체 고객 수
  SUM(ChurnValue) AS churn_cnt,                         -- 이탈 고객 수
  ROUND(SAFE_DIVIDE(SUM(ChurnValue), COUNT(*)), 4) AS churn_rate  -- 이탈률
FROM `telco-490702.telco.feature_mart`
GROUP BY InternetType
ORDER BY churn_rate DESC;                               -- 이탈률 높은 순 정렬


-- ================================================================
-- 가입기간 구간(TenureBand)별 고객 수 및 이탈률 분석
-- 목적: 가입 기간에 따른 이탈 패턴 파악 (초기 이탈 집중 여부 확인)
-- ================================================================
SELECT
  TenureBand,                                            -- 가입기간 구간 (0-5m / 6-11m / 12-23m / 24-35m / 36-47m / 48m+)
  COUNT(*) AS customer_cnt,                              -- 전체 고객 수
  SUM(ChurnValue) AS churn_cnt,                         -- 이탈 고객 수
  ROUND(SAFE_DIVIDE(SUM(ChurnValue), COUNT(*)), 4) AS churn_rate  -- 이탈률
FROM `telco-490702.telco.feature_mart`
GROUP BY TenureBand
ORDER BY TenureBand;                                    -- 가입기간 구간 순 정렬 (시계열 흐름 확인용)