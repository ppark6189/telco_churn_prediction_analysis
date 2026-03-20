SELECT
  Contract,
  COUNT(*) AS customer_cnt,
  SUM(ChurnValue) AS churn_cnt,
  ROUND(SAFE_DIVIDE(SUM(ChurnValue), COUNT(*)), 4) AS churn_rate
FROM `telco-490702.telco.feature_mart`
GROUP BY Contract
ORDER BY churn_rate DESC;

SELECT
  InternetType,
  COUNT(*) AS customer_cnt,
  SUM(ChurnValue) AS churn_cnt,
  ROUND(SAFE_DIVIDE(SUM(ChurnValue), COUNT(*)), 4) AS churn_rate
FROM `telco-490702.telco.feature_mart`
GROUP BY InternetType
ORDER BY churn_rate DESC;

SELECT
  TenureBand,
  COUNT(*) AS customer_cnt,
  SUM(ChurnValue) AS churn_cnt,
  ROUND(SAFE_DIVIDE(SUM(ChurnValue), COUNT(*)), 4) AS churn_rate
FROM `telco-490702.telco.feature_mart`
GROUP BY TenureBand
ORDER BY TenureBand;

