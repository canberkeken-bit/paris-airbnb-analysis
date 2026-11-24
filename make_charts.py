"""results/analiz_sonuclari.csv dosyasından grafikleri üretir: python make_charts.py"""
import pandas as pd
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

df = pd.read_csv("results/analiz_sonuclari.csv", dtype={"kategori": str})
TEAL, RED, GRAY = "#1f7a80", "#c0392b", "#7f8c8d"
plt.rcParams.update({"font.size": 11, "axes.spines.top": False, "axes.spines.right": False})

def etiket(ax, bars, fmt):
    for b in bars:
        ax.annotate(fmt.format(b.get_height()), (b.get_x() + b.get_width() / 2, b.get_height()),
                    ha="center", va="bottom", fontsize=10, xytext=(0, 2), textcoords="offset points")

# 1) Aylık trend: doluluk düşerken fiyat sabit
m = df[df.analiz == "4 - Aylik Trend"]
fig, (a, b) = plt.subplots(1, 2, figsize=(11, 4))
bars = a.bar(m.kategori, m.doluluk_orani_pct, color=TEAL); etiket(a, bars, "%{:.1f}")
a.set_title("Aylık doluluk oranı (%)"); a.set_ylim(0, 105)
b.plot(m.kategori, m.ortalama_fiyat, marker="o", color=RED, linewidth=2)
for x, y in zip(m.kategori, m.ortalama_fiyat): b.annotate(f"€{y:.2f}", (x, y), ha="center", xytext=(0, 8), textcoords="offset points", fontsize=10)
b.set_title("Aylık ortalama fiyat (€, eksen 150’den başlar)"); b.set_ylim(150, 165)
fig.suptitle("Kış Uykusu Hatası: talep çökerken fiyat düşmüyor", fontweight="bold")
fig.tight_layout(); fig.savefig("charts/01_aylik_trend.png", dpi=160); plt.close(fig)

# 2) Performans üstü vs altı
p = df[df.analiz == "5 - Performans Sinifi"].set_index("kategori").loc[["Performans Ustu", "Performans Alti"]]
fig, (a, b) = plt.subplots(1, 2, figsize=(9, 4))
bars = a.bar(["Performans üstü\n(325 ev)", "Performans altı\n(175 ev)"], p.doluluk_orani_pct, color=[TEAL, RED]); etiket(a, bars, "%{:.1f}")
a.set_title("Doluluk oranı (%)"); a.set_ylim(0, 105)
bars = b.bar(["Performans üstü\n(325 ev)", "Performans altı\n(175 ev)"], p.ortalama_fiyat, color=[TEAL, RED]); etiket(b, bars, "€{:.2f}")
b.set_title("Ortalama fiyat (€)"); b.set_ylim(0, 225)
fig.suptitle("Gelir paradoksu: ucuz ve dolu, pahalı ve boş", fontweight="bold")
fig.tight_layout(); fig.savefig("charts/02_performans_siniflari.png", dpi=160); plt.close(fig)

# 3) Cevap süresi → puan
c = df[df.analiz == "3 - Cevap Suresi"].set_index("kategori").loc[["within an hour", "within a few hours", "within a day", "a few days or more"]]
fig, ax = plt.subplots(figsize=(8, 4))
bars = ax.bar(["Bir saat içinde", "Birkaç saat", "Bir gün içinde", "Birkaç gün\nveya daha fazla"], c.ortalama_puan, color=[TEAL, TEAL, TEAL, RED]); etiket(ax, bars, "{:.2f}")
ax.set_ylim(3.5, 5); ax.set_title("Cevap süresine göre ortalama misafir puanı", fontweight="bold")
ax.text(0.99, 0.04, "Son grupta yalnızca 22 ilan var", transform=ax.transAxes, ha="right", fontsize=9, color=GRAY)
fig.tight_layout(); fig.savefig("charts/03_cevap_suresi_puan.png", dpi=160); plt.close(fig)

# 4) Oda tipi
o = df[df.analiz == "2 - Oda Tipi"].set_index("kategori").loc[["Entire home/apt", "Private room", "Shared room"]]
fig, (a, b) = plt.subplots(1, 2, figsize=(10, 4))
lab = ["Tüm ev/apt\n(450)", "Özel oda\n(49)", "Paylaşımlı\n(1)"]
bars = a.bar(lab, o.doluluk_orani_pct, color=TEAL); etiket(a, bars, "%{:.1f}"); a.set_ylim(0, 100); a.set_title("Doluluk oranı (%)")
bars = b.bar(lab, o.ortalama_fiyat, color=RED); etiket(b, bars, "€{:.2f}"); b.set_ylim(0, 200); b.set_title("Ortalama fiyat (€)")
fig.suptitle("Oda tipine göre portföy", fontweight="bold")
fig.tight_layout(); fig.savefig("charts/04_oda_tipi.png", dpi=160); plt.close(fig)
print("4 grafik üretildi")
