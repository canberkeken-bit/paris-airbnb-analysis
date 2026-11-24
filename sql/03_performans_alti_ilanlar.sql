/* ============================================
   ANALİZ: NEDEN PERFORMANS ALTI?
   Amaç: ortalama doluluk altında kalan ilanların
   hangi KPI'da zayıf olduğunu bul
   ============================================ */
WITH genel AS (
  -- Tüm pazarın ortalama değerleri
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
  -- Her ilanın kendi KPI değerleri
  SELECT
    l.id,
    l.room_type,
    l.host_response_time,
    ROUND(l.review_scores_value, 2) AS puan,
    ROUND(COUNTIF(c.available = false) * 100.0 / COUNT(*), 1) AS doluluk_orani_pct,
    ROUND(AVG(c.price), 2) AS ortalama_fiyat
  FROM `data-analytics-469406.airbnb.listing` l
  JOIN `data-analytics-469406.airbnb.calendar` c
    ON l.id = c.listing_id
  WHERE c.price IS NOT NULL
    AND c.price > 0
  GROUP BY l.id, l.room_type, l.host_response_time, l.review_scores_value
),

sonuc AS (
  SELECT
    i.id,
    i.room_type,
    i.host_response_time,
    i.puan,
    i.doluluk_orani_pct,
    i.ortalama_fiyat,
    g.ort_doluluk,
    g.ort_fiyat,
    g.ort_puan,

    -- Performans sınıfı
    CASE
      WHEN i.doluluk_orani_pct >= g.ort_doluluk THEN 'Performans Ustu'
      ELSE 'Performans Alti'
    END AS performans_sinifi,

    -- Hangi KPI sebebiyle aşağıda kaldı?
    CASE
      WHEN i.doluluk_orani_pct >= g.ort_doluluk
        THEN 'Sorun yok'
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
      ELSE 'Veri disinda sebep (konum, fotograf vb.)'
    END AS asagi_kalma_sebebi
  FROM ilan_kpi i
  CROSS JOIN genel g
)

-- Sadece performans altı ilanları getir
SELECT *
FROM sonuc
WHERE performans_sinifi = 'Performans Alti'
ORDER BY doluluk_orani_pct;
