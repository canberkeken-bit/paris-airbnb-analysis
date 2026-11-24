"""Raporda geçen sayıların results/analiz_sonuclari.csv ile birebir uyuştuğunu denetler."""
import pandas as pd
df = pd.read_csv("results/analiz_sonuclari.csv", dtype={"kategori": str}).set_index(["analiz", "kategori"])
rapor = {  # (analiz, kategori): (ilan, doluluk, fiyat, puan)
 ("1 - Genel KPI","Tum Paris"):(500,75.7,158.02,4.67),
 ("2 - Oda Tipi","Entire home/apt"):(450,76.2,165.98,None),
 ("2 - Oda Tipi","Private room"):(49,70.7,87.39,None),
 ("2 - Oda Tipi","Shared room"):(1,83.3,41.44,4.74),
 ("3 - Cevap Suresi","within an hour"):(None,78.3,None,4.68),
 ("3 - Cevap Suresi","within a few hours"):(None,74.3,None,4.70),
 ("3 - Cevap Suresi","within a day"):(None,73.3,None,4.69),
 ("3 - Cevap Suresi","a few days or more"):(None,73.0,None,4.24),
 ("4 - Aylik Trend","2022-09"):(None,93.1,158.15,None),
 ("4 - Aylik Trend","2022-10"):(None,86.4,157.85,None),
 ("4 - Aylik Trend","2022-11"):(None,73.0,155.49,None),
 ("4 - Aylik Trend","2022-12"):(None,69.4,159.22,None),
 ("4 - Aylik Trend","2023-01"):(None,62.0,159.35,None),
 ("5 - Performans Sinifi","Performans Ustu"):(325,92.7,140.76,4.68),
 ("5 - Performans Sinifi","Performans Alti"):(175,44.1,190.11,4.64),
}
hata = 0
for k, v in rapor.items():
    r = df.loc[k]
    for ad, beklenen in zip(["ilan_sayisi","doluluk_orani_pct","ortalama_fiyat","ortalama_puan"], v):
        if beklenen is not None and abs(float(r[ad]) - beklenen) > 1e-9:
            print("UYUŞMAZLIK", k, ad, r[ad], beklenen); hata += 1
u, a = df.loc[("5 - Performans Sinifi","Performans Ustu")], df.loc[("5 - Performans Sinifi","Performans Alti")]
print("Fiyat farkı:", round(a.ortalama_fiyat - u.ortalama_fiyat, 2), "€ | Ocak-Eylül doluluk farkı:", round(93.1-62.0,1), "puan")
print("Toplam ilan (performans sınıfı):", int(u.ilan_sayisi + a.ilan_sayisi), "| oda tipi:", int(df.loc["2 - Oda Tipi"].ilan_sayisi.sum()), "| cevap süresi:", int(df.loc["3 - Cevap Suresi"].ilan_sayisi.sum()))
print("TAMAM: rapor ve sonuç tablosu uyuşuyor" if hata == 0 else f"{hata} uyuşmazlık")
