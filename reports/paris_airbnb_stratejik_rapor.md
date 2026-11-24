# Paris Airbnb Ekosistemi: Performans, Trendler ve Büyüme Stratejileri

Bu rapor, Paris pazarındaki 500 evlik mevcut envanterin veri analizine dayanır. Amaç, pazarın genel sağlığını değerlendirmekten çok, "güven verici ortalamaların" ardındaki farkları göstermek ve karlılık farkını kapatacak adımları önermektir.

---

## 1. Pazar Sağlığı ve Genel KPI Analizi

| Metrik | Değer |
|---|---|
| **Toplam Envanter** | 500 Ev |
| **Ortalama Doluluk** | %75.7 |
| **Ortalama Fiyat** | €158.02 |
| **Ortalama Puan** | 4.67 |

**Uyarı:** Bu ortalamalar tek başına yanıltıcıdır; gerçek karlılık farkı, aşağıdaki kırılımlarda görünür.

---

## 2. Portföy Yapısı ve Segmentasyon

Paris envanteri %90 oranında "Tüm Ev/Apartman" tipi konaklamalardan oluşur.

* **Tüm Ev/Apartman:** 450 Ev (%90 pazar payı), Doluluk %76.2, Ortalama Fiyat €165.98
* **Özel Oda:** 49 Ev (%10 pazar payı), Doluluk %70.7, Ortalama Fiyat €87.39
* **Paylaşımlı Oda:** 1 Ev, Doluluk %83.3, Ortalama Fiyat €41.44, **Ortalama Puan 4.74**

Paylaşımlı oda en yüksek puana sahiptir, ancak tek ilanlık bir segment olduğu için buradan genel bir sonuç çıkarılamaz.

---

## 3. Gelir Paradoksu: Performans Üstü ve Altı

"Performans üstü" ilanlar, doluluğu pazar ortalamasının (%75.7) üstünde olanlardır; geri kalanı "performans altı" sayılır. Performans altı grup, evlerini boş tutarken gecelik yaklaşık €50 daha yüksek fiyat istemektedir (190.11 − 140.76 = €49.35).

| Metrik | Performans Üstü (325 Ev) | Performans Altı (175 Ev) |
|---|---|---|
| **Yaklaşım** | Yüksek doluluk | Yüksek fiyat |
| **Doluluk Oranı** | **%92.7** | %44.1 |
| **Ortalama Fiyat** | **€140.76** | €190.11 |
| **Ortalama Puan** | 4.68 | 4.64 |

**Not:** Fiyatı pazarın kabul edeceği seviyede tutup doluluğu yüksek tutan evler, toplam gelirde öndedir.

---

## 4. İletişim Hızı

Ev sahibinin yanıt süresine göre misafir puanı ve doluluk:

* **Bir saat içinde:** 4.68 Puan, %78.3 Doluluk
* **Birkaç saat içinde:** 4.70 Puan, %74.3 Doluluk
* **Bir gün içinde:** 4.69 Puan, %73.3 Doluluk
* **Birkaç gün veya daha fazla:** **4.24 Puan**, %73.0 Doluluk

Yanıt süresi bir günü aştığında ortalama puan 4.24'e düşmektedir. Bu grup yalnızca 22 ilandan oluşur.

---

## 5. Aylık Trend (Eylül 2022 – Ocak 2023)

* **Eylül 2022:** %93.1 Doluluk, €158.15 Fiyat
* **Ekim 2022:** %86.4 Doluluk, €157.85 Fiyat
* **Kasım 2022:** %73.0 Doluluk, €155.49 Fiyat
* **Aralık 2022:** %69.4 Doluluk, **€159.22 Fiyat**
* **Ocak 2023:** %62.0 Doluluk, **€159.35 Fiyat**

Doluluk 31 puan düşerken ortalama fiyat Ocak ayında €159.35'e çıkmıştır. Talep azalırken fiyatın sabit kalması veya artması, boş gün riskini büyütür.

---

## 6. Performans Altı İlanlarda Görülen Zayıf Noktalar

Performans altı 175 evin geride kalmasında şu kombinasyonlar öne çıkar:

1. Yüksek fiyat (€190+) ve düşük doluluk (%44)
2. Yavaş yanıt süresi ve düşük puan (4.24)
3. Düşen sezonda (Ocak) sabit veya artan fiyat (€159+)
4. Düşük puan (4.64) ve pazar üstü fiyat (€190)
5. Bir günü aşan yanıt süresi
6. Özel oda segmentinde tüm ev fiyatlandırması
7. Yavaş iletişim, düşen puan ve sabit fiyat birlikte

Her sebebin kaç ilanda görüldüğü `sql/02_asagi_kalma_sebepleri_ozeti.sql` ile, ilan bazlı liste `sql/03_performans_alti_ilanlar.sql` ile çıkarılır.

---

## 7. Aksiyon Adımları

1. **Doluluğu önceleyin:** Fiyat tavanını değil doluluk oranını optimize edin. %92.7 doluluk ile €140.76, %44.1 doluluk ile €190.11'den daha fazla gelir üretir.
2. **24 saat içinde yanıt verin:** Yanıt süresinin bir günü geçmesi, puanın 4.24 seviyesine inmesiyle birlikte görülüyor.
3. **Sezona göre fiyatı esnetin:** Kış aylarında talep düşerken fiyatı sabit tutmak veya artırmak gelir kaybına yol açar.

---

### Verinin sınırları

* Doluluk, takvimde `available = false` olan günlerin oranıdır. Bu, gerçekten rezerve edilmiş günleri ve ev sahibinin kendi kapattığı günleri ayıramaz.
* Veri 5 aylık bir dönemi (Eylül 2022 – Ocak 2023) kapsar; yıllık sezonluk sonuç çıkarmak için yetersizdir.
* Fiyat ve doluluk arasındaki ilişki gözlemseldir. Fiyatı düşürmenin dolulukla gelir artıracağı bu veriyle kanıtlanmaz.
* "Performans altı" sınıfı doluluk ortalamasına göre tanımlandığından, doluluk ile fiyatın karşılaştırması kısmen kendi kendini doğrular.
* Yanıt süresi "birkaç gün veya daha fazla" grubu 22 ilandır; paylaşımlı oda segmenti 1 ilandır.
