/* ============================================
   ANALİZ 1-5: Genel KPI, oda tipi, cevap süresi,
   aylık trend ve performans sınıfı (tek tabloda)
   Veri: BigQuery  data-analytics-469406.airbnb  (listing + calendar)
   ============================================ */
WITH base AS (
  SELECT
    l.id,
    l.room_type,
    l.host_response_time,
    l.review_scores_value,
    c.date,
    c.available,
    c.price
  FROM `data-analytics-469406.airbnb.listing` l
  JOIN `data-analytics-469406.airbnb.calendar` c
    ON l.id = c.listing_id
  WHERE c.price IS NOT NULL
    AND c.price > 0
),

genel_ortalama AS (
  SELECT
    ROUND(COUNTIF(available = false) * 100.0 / COUNT(*), 1) AS ort_doluluk
  FROM base
),

ilan_doluluk AS (
  SELECT
    id,
    room_type,
    host_response_time,
    review_scores_value,
    ROUND(COUNTIF(available = false) * 100.0 / COUNT(*), 1) AS doluluk_orani_pct,
    ROUND(AVG(price), 2) AS ortalama_fiyat
  FROM base
  GROUP BY id, room_type, host_response_time, review_scores_value
)

/* ---- ANALİZ 1: GENEL KPI ---- */
SELECT
  '1 - Genel KPI' AS analiz,
  'Tum Paris'     AS kategori,
  COUNT(DISTINCT id) AS ilan_sayisi,
  ROUND(COUNTIF(available = false) * 100.0 / COUNT(*), 1) AS doluluk_orani_pct,
  ROUND(AVG(price), 2) AS ortalama_fiyat,
  ROUND(AVG(review_scores_value), 2) AS ortalama_puan
FROM base

UNION ALL

/* ---- ANALİZ 2: ODA TİPİNE GÖRE ---- */
SELECT
  '2 - Oda Tipi' AS analiz,
  room_type      AS kategori,
  COUNT(DISTINCT id) AS ilan_sayisi,
  ROUND(COUNTIF(available = false) * 100.0 / COUNT(*), 1) AS doluluk_orani_pct,
  ROUND(AVG(price), 2) AS ortalama_fiyat,
  ROUND(AVG(review_scores_value), 2) AS ortalama_puan
FROM base
GROUP BY room_type

UNION ALL

/* ---- ANALİZ 3: CEVAP SÜRESİNE GÖRE ---- */
SELECT
  '3 - Cevap Suresi' AS analiz,
  host_response_time AS kategori,
  COUNT(DISTINCT id) AS ilan_sayisi,
  ROUND(COUNTIF(available = false) * 100.0 / COUNT(*), 1) AS doluluk_orani_pct,
  ROUND(AVG(price), 2) AS ortalama_fiyat,
  ROUND(AVG(review_scores_value), 2) AS ortalama_puan
FROM base
GROUP BY host_response_time

UNION ALL

/* ---- ANALİZ 4: AYLIK TREND ---- */
SELECT
  '4 - Aylik Trend' AS analiz,
  FORMAT_DATE('%Y-%m', date) AS kategori,
  COUNT(DISTINCT id) AS ilan_sayisi,
  ROUND(COUNTIF(available = false) * 100.0 / COUNT(*), 1) AS doluluk_orani_pct,
  ROUND(AVG(price), 2) AS ortalama_fiyat,
  ROUND(AVG(review_scores_value), 2) AS ortalama_puan
FROM base
GROUP BY FORMAT_DATE('%Y-%m', date)

UNION ALL

/* ---- ANALİZ 5: PERFORMANS SINIFI ---- */
SELECT
  '5 - Performans Sinifi' AS analiz,
  CASE
    WHEN d.doluluk_orani_pct >= g.ort_doluluk THEN 'Performans Ustu'
    ELSE 'Performans Alti'
  END AS kategori,
  COUNT(*) AS ilan_sayisi,
  ROUND(AVG(d.doluluk_orani_pct), 1) AS doluluk_orani_pct,
  ROUND(AVG(d.ortalama_fiyat), 2) AS ortalama_fiyat,
  ROUND(AVG(d.review_scores_value), 2) AS ortalama_puan
FROM ilan_doluluk d
CROSS JOIN genel_ortalama g
GROUP BY kategori, g.ort_doluluk

ORDER BY analiz, doluluk_orani_pct DESC;
