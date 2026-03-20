-- ================================================================
-- analysis_base 테이블 생성
-- 목적: 분산된 고객 관련 테이블을 CustomerID 기준으로 통합해
--       분석 및 모델링에 바로 사용할 수 있는 기반 테이블 구성
-- ================================================================
CREATE OR REPLACE TABLE `telco-490702.telco.analysis_base` AS

WITH base AS (
  SELECT
    -- ── 고객 기본 ID ──────────────────────────────────────────
    c.CustomerID AS CustomerID,

    -- ── 인구통계 (Demographics) ───────────────────────────────
    d.`Gender`          AS Gender,          -- 성별
    d.`Age`             AS Age,             -- 나이
    d.`Senior Citizen`  AS SeniorCitizen,   -- 시니어 여부 (65세 이상)
    d.`Married`         AS Married,         -- 결혼 여부
    d.`Dependents`      AS Dependents,      -- 부양가족 여부

    -- ── 서비스 이용 정보 (Services) ───────────────────────────
    s.`Tenure in Months` AS TenureInMonths, -- 가입 기간 (월 단위)
    s.`Offer`            AS Offer,          -- 가입 시 적용된 프로모션 오퍼
    s.`Phone Service`    AS PhoneService,   -- 전화 서비스 가입 여부
    s.`Internet Service` AS InternetService,-- 인터넷 서비스 가입 여부
    s.`Internet Type`    AS InternetType,   -- 인터넷 유형 (Fiber Optic / DSL / Cable 등)
    s.`Contract`         AS Contract,       -- 계약 형태 (Month-to-Month / One Year / Two Year)
    s.`Payment Method`   AS PaymentMethod,  -- 결제 방식 (Credit Card / Bank Withdrawal 등)

    -- 요금 관련 컬럼은 문자열로 저장된 경우가 있어 SAFE_CAST로 숫자 변환
    -- SAFE_CAST: 변환 실패 시 에러 대신 NULL 반환
    SAFE_CAST(s.`Monthly Charge` AS NUMERIC)                        AS MonthlyCharge,  -- 월 청구 요금
    COALESCE(SAFE_CAST(s.`Total Charges` AS NUMERIC), 0)            AS TotalCharges,   -- 누적 청구 요금 (NULL이면 0으로 대체)
    SAFE_CAST(s.`Total Revenue` AS NUMERIC)                         AS TotalRevenue,   -- 총 매출액

    -- ── 고객 상태 정보 (Status) ───────────────────────────────
    st.`Satisfaction Score` AS SatisfactionScore, -- 고객 만족도 점수 (1~5)
    st.`Customer Status`    AS CustomerStatus,    -- 현재 고객 상태 (Stayed / Churned / Joined)
    st.`Churn Label`        AS ChurnLabel,        -- 이탈 여부 레이블 (Yes / No)
    st.`Churn Value`        AS ChurnValue,        -- 이탈 여부 수치 (1: 이탈 / 0: 유지) ← 모델 타깃 변수
    st.`Churn Score`        AS ChurnScore,        -- 이탈 가능성 점수
    st.`CLTV`               AS CLTV,              -- 고객 생애 가치 (Customer Lifetime Value)
    st.`Churn Category`     AS ChurnCategory,     -- 이탈 카테고리 (가격 / 서비스 / 경쟁사 등)
    st.`Churn Reason`       AS ChurnReason,       -- 이탈 세부 사유

    -- ── 지역 정보 (Location) ──────────────────────────────────
    l.`Country`   AS Country,   -- 국가
    l.`State`     AS State,     -- 주(State)
    l.`City`      AS City,      -- 도시
    l.`Zip Code`  AS ZipCode,   -- 우편번호
    l.`Latitude`  AS Latitude,  -- 위도
    l.`Longitude` AS Longitude, -- 경도

    -- ── 지역 인구 정보 (Population) ───────────────────────────
    -- Location 테이블의 Zip Code를 기준으로 인구 정보 조인
    p.`Population` AS Population -- 해당 우편번호 지역 인구 수

  FROM `telco-490702.telco.Telco_customer_churn` c

    -- 모든 조인은 LEFT JOIN: 매핑 정보가 없어도 고객 행 유지
    LEFT JOIN `telco-490702.telco.Telco_customer_churn_demographics` d
      ON c.CustomerID = d.`Customer ID`

    LEFT JOIN `telco-490702.telco.Telco_customer_churn_services` s
      ON c.CustomerID = s.`Customer ID`

    LEFT JOIN `telco-490702.telco.Telco_customer_churn_status` st
      ON c.CustomerID = st.`Customer ID`

    LEFT JOIN `telco-490702.telco.Telco_customer_churn_location` l
      ON c.CustomerID = l.`Customer ID`

    -- 인구 정보는 CustomerID가 아닌 Zip Code 기준으로 조인
    LEFT JOIN `telco-490702.telco.Telco_customer_churn_population` p
      ON l.`Zip Code` = p.`Zip Code`
)

-- CTE 결과를 그대로 테이블로 저장
SELECT *
FROM base;