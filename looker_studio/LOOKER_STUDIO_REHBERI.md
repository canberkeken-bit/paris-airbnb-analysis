# Looker Studio Panosu: Adım Adım

Bu klasördeki 5 CSV, `results/analiz_sonuclari.csv` tablosundan Looker Studio için ayrılmış hazır veri kaynaklarıdır. Veriyi iki yoldan bağlayabilirsin.

## Veri bağlama (iki yoldan biri)

**A) CSV yükleme (en hızlısı):** lookerstudio.google.com → Oluştur → Rapor → Veri ekle → **Dosya Yükle** → CSV'yi seç. Beş dosya için beş kez tekrarla.

**B) BigQuery'den canlı:** Veri ekle → **BigQuery** → Özel Sorgu. `sql/01_genel_analizler.sql` içeriğini yapıştır (proje kimliğini seç). Sonuç tek tabloda gelir; her grafikte `analiz` alanına filtre koyman gerekir. CSV yolu daha kolaydır, çünkü her grafik kendi tablosunu kullanır.

Not: Aylık trendin `ay` alanını Looker Studio'da **Tarih (YYYY-AA-GG)** türüne çevir. Her tabloda kategori başına tek satır olduğu için metriklerin toplamı, ortalaması ile aynıdır; yine de skor kartlarında toplam yerine **Ortalama** seçersen yanlış sonuç çıkma riski kalmaz.

## Sayfa 1: Genel Bakış

| Bileşen | Veri kaynağı | Ayar |
|---|---|---|
| 4 skor kartı | ls_01_genel_kpi | Toplam envanter (ilan_sayisi), Doluluk (doluluk_orani_pct), Fiyat (ortalama_fiyat), Puan (ortalama_puan). Fiyata `€` öneki, doluluğa `%` soneki ekle. |
| Pasta/halka grafik: portföy yapısı | ls_02_oda_tipi | Boyut: kategori, Metrik: ilan_sayisi |
| Çubuk grafik: oda tipine göre doluluk | ls_02_oda_tipi | Boyut: kategori, Metrik: doluluk_orani_pct |

## Sayfa 2: Kazananlar ve Kaybedenler

| Bileşen | Veri kaynağı | Ayar |
|---|---|---|
| Çubuk grafik: doluluk | ls_05_performans_sinifi | Boyut: kategori, Metrik: doluluk_orani_pct. Üst: yeşil-teal, alt: kırmızı |
| Çubuk grafik: ortalama fiyat | ls_05_performans_sinifi | Boyut: kategori, Metrik: ortalama_fiyat |
| Tablo | ls_05_performans_sinifi | Tüm alanlar, ilan_sayisi dahil |

Başlık önerisi: "Performans altı gruplar daha pahalı, ama çok daha boş." Altına küçük not: aradaki fark gecelik yaklaşık €49.

## Sayfa 3: İletişim Hızı

| Bileşen | Veri kaynağı | Ayar |
|---|---|---|
| Çubuk grafik: ortalama puan | ls_03_cevap_suresi | Boyut: kategori, Metrik: ortalama_puan. Eksen alt sınırı 3.5 (grafiği abartmamak için başlığa "eksen 3.5'ten başlar" yaz). |
| Tablo: ilan sayısı ve doluluk | ls_03_cevap_suresi | Son satır yalnızca 22 ilan, kutu içinde belirt. |

## Sayfa 4: Aylık Trend

| Bileşen | Veri kaynağı | Ayar |
|---|---|---|
| Birleşik grafik (**Birleşik: çubuk + çizgi**) | ls_04_aylik_trend | Boyut: ay. Çubuk: doluluk_orani_pct. Çizgi: ortalama_fiyat, **sağ eksende**. |

Dikkat: Çift eksen karışıklık yaratır. Okunaklı olması için çizginin eksen alt sınırını 150 yap ve altına "doluluk 31 puan düşerken fiyat sabit kaldı" notunu yaz. Alternatif: iki ayrı grafik koy (`charts/01_aylik_trend.png` gibi).

## Genel ayarlar

- **Tema:** Özel tema, birincil renk teal `#1F7A80`, uyarı rengi `#C0392B`.
- **Filtre:** Sayfa 3 ve 4 için tarih veya kategori filtresine gerek yok, veri zaten özet.
- **Paylaşım:** Sağ üst Paylaş → "Bağlantıyı bilen herkes görüntüleyebilir". Bağlantıyı README'ye ekle.
- **Rapor sınırları:** Yanıt süresi grubunda 22 ilan, paylaşımlı oda segmentinde 1 ilan var. Bu gruplar için yorum eklerken "küçük örneklem" notunu koru.
