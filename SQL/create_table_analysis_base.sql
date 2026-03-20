CREATE OR REPLACE TABLE `telco-490702.telco.analysis_base` AS
WITH base AS (
  SELECT
    c.CustomerID AS CustomerID,

    d.`Gender` AS Gender,
    d.`Age` AS Age,
    d.`Senior Citizen` AS SeniorCitizen,
    d.`Married` AS Married,
    d.`Dependents` AS Dependents,

    s.`Tenure in Months` AS TenureInMonths,
    s.`Offer` AS Offer,
    s.`Phone Service` AS PhoneService,
    s.`Internet Service` AS InternetService,
    s.`Internet Type` AS InternetType,
    s.`Contract` AS Contract,
    s.`Payment Method` AS PaymentMethod,
    SAFE_CAST(s.`Monthly Charge` AS NUMERIC) AS MonthlyCharge,
    COALESCE(SAFE_CAST(s.`Total Charges` AS NUMERIC), 0) AS TotalCharges,
    SAFE_CAST(s.`Total Revenue` AS NUMERIC) AS TotalRevenue,

    st.`Satisfaction Score` AS SatisfactionScore,
    st.`Customer Status` AS CustomerStatus,
    st.`Churn Label` AS ChurnLabel,
    st.`Churn Value` AS ChurnValue,
    st.`Churn Score` AS ChurnScore,
    st.`CLTV` AS CLTV,
    st.`Churn Category` AS ChurnCategory,
    st.`Churn Reason` AS ChurnReason,

    l.`Country` AS Country,
    l.`State` AS State,
    l.`City` AS City,
    l.`Zip Code` AS ZipCode,
    l.`Latitude` AS Latitude,
    l.`Longitude` AS Longitude,

    p.`Population` AS Population

  FROM `telco-490702.telco.Telco_customer_churn` c
  LEFT JOIN `telco-490702.telco.Telco_customer_churn_demographics` d
    ON c.CustomerID = d.`Customer ID`
  LEFT JOIN `telco-490702.telco.Telco_customer_churn_services` s
    ON c.CustomerID = s.`Customer ID`
  LEFT JOIN `telco-490702.telco.Telco_customer_churn_status` st
    ON c.CustomerID = st.`Customer ID`
  LEFT JOIN `telco-490702.telco.Telco_customer_churn_location` l
    ON c.CustomerID = l.`Customer ID`
  LEFT JOIN `telco-490702.telco.Telco_customer_churn_population` p
    ON l.`Zip Code` = p.`Zip Code`
)
SELECT *
FROM base;
