# Ödev Raporu

**Ödev no:** Ödev 2     **Hafta:** 7     **Tarih:** 27 / 11 / 2026

**Ad Soyad:** Artun Toprak Dereli  **Öğrenci No:** 202607131017

**Program:** ☒ Yapay Zeka Operatörlüğü  ☐ Robotik ve Yapay Zeka

**Kullandığım veritabanı:** ☐ `llm_ops`  ☒ `robot_fleet`

**PR bağlantısı:** `https://github.com/artuntprk/vize-202607131017/pull/2`

**Commit sayısı:** 4

---

## 1. Fan-out

**Soru 4'te toplam kaçtan kaça çıktı?**

JOIN ile hesaplanan (hatalı) toplam batarya: **700**. JOIN kullanmadan hesaplanan doğru toplam: **262**. Fark 438 puan, yani hatalı sonuç doğru değerin yaklaşık 2,7 katı.

**Hangi robot kaç kez sayıldı?**

Görevi olan 6 robot, kaç görevleri varsa o kadar kez sayıldı: Kartal-01, Kartal-03 ve Atlas-01 üçer görevleri olduğu için üçer kez; Mars-01 ve Mars-02 ikişer görevleri olduğu için ikişer kez; Atlas-02 tek görevi olduğu için sadece bir kez (bu yüzden onda hata oluşmadı). Hiç görevi olmayan 4 robot (Kartal-02, Kartal-04, Atlas-03, Mars-03) ise INNER JOIN'de hiç görünmediği için toplamda hiç sayılmadı.

**Gerçek bir raporda bu hata ne yanlışa yol açar?**

Örneğin bir filo yöneticisi "toplam 700 birim batarya kapasitemiz var" diye yanlış bir sonuca varıp buna göre planlama yapabilir (örn. yeterli yedek güç olduğunu düşünüp şarj istasyonu yatırımını erteleyebilir), oysa gerçek toplam kapasite 262'dir. JOIN'den sonra toplama/ortalama alırken "bire-çok" ilişkiden kaynaklanan satır çoğalmasını (fan-out) hesaba katmamak, finansal veya operasyonel kararların yanlış veriye dayanmasına yol açar.

## 2. En zor karar

**Kendi ERD'nde en çok düşündüğün tek karar neydi?**

En çok düşündüğüm karar, puanlayıcıya ait `lm_familiarity` ve `lm_frequency_use` sütunlarını ayrı bir RATERS tablosuna mı çıkaracağım, yoksa tek bir düz RATINGS tablosunda mı tutacağımdı.

**Hangi seçenekler arasında kaldın, neden birini seçtin?**

Bir seçenek, vizede olduğu gibi her şeyi tek bir `ratings` tablosunda tutmaktı — bu, sorgulamayı basitleştirir (JOIN gerektirmez) ama aynı puanlayıcının bilgisi her puan satırında tekrar eder (redundancy). Diğer seçenek, bu sütunları `rater_id`'ye bağlı ayrı bir tabloya taşımaktı. İkinci seçeneği seçtim çünkü `lm_familiarity` yalnızca puanlayıcıya bağlıdır, puana değil; tek tabloda tutmak 2NF'yi ihlal eden kısmi bir bağımlılık yaratırdı. Ayrıca Hafta 7'de işlenen doğal anahtar/yapay anahtar tartışmasını da göz önünde bulundurdum: `rater_id`'yi birincil anahtar olarak kullanmak, ileride aynı kişinin tekrar katılması gibi bir durumda sorun çıkarabilir, ama PRISM veri setinde `rater_id` zaten benzersiz ve sabit olduğu için bunu doğal anahtar olarak kullanmaya karar verdim.

---

## 5. Yapay zeka kullanım beyanı

☐ Bu ödevde yapay zeka aracı **kullanmadım.**

☒ Kullandım, aşağıda belirttim:

| Soru no | Araç | Ne sordum (özet) | Cevabı nasıl doğruladım |
|---|---|---|---|
| Bölüm 1 (5 sorgu) | Claude | robot_fleet şemasına göre INNER/LEFT JOIN, fan-out ve count(*) vs count(m.id) karşılaştırması için SQL sorguları yazmasını istedim | Her sorguyu kendi bilgisayarımda psql ile çalıştırdım, dönen satır sayılarını ve değerleri (ör. 9 satır, 700 vs 262) tek tek kontrol ettim, yorumları bu gerçek çıktılara göre yazdım |
| Bölüm 2.1 (ERD) | Claude | Vize projemdeki (PRISM) düz ratings tablosunu normalize eden bir Mermaid ERD önermesini istedim | Veri kartımdaki (data/README.md) gerçek sütun adlarıyla (lm_familiarity, lm_frequency_use, score_1_5 vb.) karşılaştırıp önerilen şemayı kendi verimle eşleştirdim |
| Bölüm 2.2-2.3 | Claude | Normalizasyon gerekçesi ve iki JOIN sorusu yazmasını istedim | Kendi şemama ve derste işlenen 1NF/2NF/3NF tanımlarına uygunluğunu kontrol ettim |

> "Nasıl doğruladım" sütunu en önemlisi. "Çalıştırdım, 4 satır döndü, tabloyla karşılaştırdım" gibi somut bir şey yaz.

---

## 6. Öz değerlendirme

Rubriğe ([RUBRIK.md](../../RUBRIK.md)) göre kendine bir seviye ver. Bu puanını etkilemez.

| Ölçüt | 4 Tam | 3 İyi | 2 Gelişmeli | 1 Yetersiz |
|---|---|---|---|---|
| A, Doğruluk | ☒ | ☐ | ☐ | ☐ |
| B, SQL kalitesi | ☒ | ☐ | ☐ | ☐ |
| C, Yorum ve analiz | ☒ | ☐ | ☐ | ☐ |
| D, Git ve PR disiplini | ☐ | ☒ | ☐ | ☐ |
| E, Dürüstlük ve beyan | ☒ | ☐ | ☐ | ☐ |

Bir dahaki ödevde daha iyi yapacağım şey: Dosyaları commit etmeden önce git status ile doğru klasöre gittiğini kontrol etmek (bu ödevde bir dosya yanlış klasöre kaydedilmiş, sonradan düzeltmem gerekti).

---

## 7. Bana sorun

Anlamadığın, merak ettiğin ya da derste tekrar görmek istediğin bir konu:

Doğal anahtar (natural key) ile yapay anahtar (surrogate key) arasında hangi durumlarda hangisini seçmemiz gerektiğine dair daha fazla örnek görmek isterim.

---

**İmza:** ________________________

---

*Doğruluk beyanı: Bu çalışmayı kendim yaptım. Kullandığım tüm yardımcı kaynakları ve yapay zeka araçlarını yukarıda beyan ettim.*