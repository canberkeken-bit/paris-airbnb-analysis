/* ============================================
   ANALİZ: AŞAĞI KALMA SEBEPLERİ ÖZETİ
   Amaç: her sebebin kaç ilanda görüldüğünü say
   ============================================ */
WITH genel AS (
  SELECT
    ROUND(COUNTIF(c.available = false) * 100.0 / COUNT(*), 1) AS ort_doluluk,
    ROUND(AVG(c.price), 2) AS ort_fiyat,
    ROUND(AVG(l.review_scores_value), 2) AS ort_puan
  FROM `data-analytics-469406.airbnb.listing` l
  JOIN `data-analytics-469406.airbnb.calendar` c
    ON l.id = c.listing_id
  WHERE c.price IS NOT NULL
    AND c.price > 0
),

ilan_kpi AS (
  SELECT
    l.id,
    l.host_response_time,
    ROUND(l.review_scores_value, 2) AS puan,
    ROUND(COUNTIF(c.available = false) * 100.0 / COUNT(*), 1) AS doluluk_orani_pct,
    ROUND(AVG(c.price), 2) AS ortalama_fiyat
  FROM `data-analytics-469406.airbnb.listing` l
  JOIN `data-analytics-469406.airbnb.calendar` c
    ON l.id = c.listing_id
  WHERE c.price IS NOT NULL
    AND c.price > 0
  GROUP BY l.id, l.host_response_time, l.review_scores_value
),

sonuc AS (
  SELECT
    CASE
      WHEN i.host_response_time = 'a few days or more'
        AND i.puan < g.ort_puan
        AND i.ortalama_fiyat > g.ort_fiyat
        THEN 'Yavas cevap + dusuk puan + yuksek fiyat'
      WHEN i.host_response_time = 'a few days or more'
        AND i.puan < g.ort_puan
        THEN 'Yavas cevap + dusuk puan'
      WHEN i.host_response_time = 'a few days or more'
        AND i.ortalama_fiyat > g.ort_fiyat
        THEN 'Yavas cevap + yuksek fiyat'
      WHEN i.host_response_time = 'a few days or more'
        THEN 'Yavas cevap suresi'
      WHEN i.puan < g.ort_puan
        AND i.ortalama_fiyat > g.ort_fiyat
        THEN 'Dusuk puan + yuksek fiyat'
      WHEN i.puan < g.ort_puan
        THEN 'Dusuk puan'
      WHEN i.ortalama_fiyat > g.ort_fiyat
        THEN 'Yuksek fiyat'
      ELSE 'Veri disinda sebep'
    END AS asagi_kalma_sebebi
  FROM ilan_kpi i
  CROSS JOIN genel g
  WHERE i.doluluk_orani_pct < g.ort_doluluk
)

-- Her sebebin yanına ilan sayısını getir
SELECT
  asagi_kalma_sebebi,
  COUNT(*) AS ilan_sayisi
FROM sonuc
GROUP BY asagi_kalma_sebebi
ORDER BY ilan_sayisi DESC;
