-- Vize Hafta 5 sorguları (Kura #18). Tablo: ratings, raters (bkz. scripts/build_ratings.py)

-- Q1: Puanlayıcı başına puan sayısı ve ortalama, genel ortalamadan farkla (GROUP BY, ROUND)
-- Soru: Hangi puanlayıcılar genel ortalamadan en çok sapıyor?
-- Beklenti: Bazı puanlayıcılar belirgin biçimde sert ya da cömert çıkacak.
-- Sonuç ve anlamı: Genel ortalama 65,13. Genel ortalamadan en çok yukarı sapan 10 puanlayıcının ortalaması 89,9 ile 100,0 arasında, farklar +24,8 ile +34,9 puan. user186 (40 puan) ve user1270 (35 puan) ortalaması 100,0, yani hemen hemen bütün puanları 100. Bu kişiler çok cömert olabilir ya da puanları ayırt etmeden vermiş olabilir, bu sorgu ikisini ayıramaz. Sorgu yalnızca en cömert ucu gösteriyor.
SELECT rater_id,
       COUNT(*) AS puan_sayisi,
       ROUND(AVG(score), 1) AS ort_puan,
       ROUND(AVG(score) - (SELECT AVG(score) FROM ratings), 1) AS genel_ort_farki
FROM ratings
GROUP BY rater_id
ORDER BY genel_ort_farki DESC
LIMIT 10;

-- Q2: Ölçek dışı puan ve boş model cevabı sayısı; boş cevaplar çıkarılınca ortalamanın değişimi (FILTER, CASE WHEN)
-- Soru: 1-100 dışında puan var mı ve boş cevaplar ortalamayı ne kadar çekiyor?
-- Beklenti: Ölçek dışı puan yok; boş cevaplar ortalamayı biraz aşağı çekiyor.
-- Sonuç ve anlamı: Ölçek dışı (1-100 dışı) puan yok. 147 boş model cevabı var (68.371 puanın yaklaşık %0,2'si). Boş cevaplar dahil ortalama 65,13, hariç 65,25, fark yalnızca 0,12 puan. Boş cevaplar sayıca az olduğu için ortalamayı neredeyse etkilemiyor; yine de silinmedi, ayrı raporlandı.
SELECT COUNT(*) FILTER (WHERE score < 1 OR score > 100) AS olcek_disi,
       COUNT(*) FILTER (WHERE is_empty) AS bos_cevap,
       ROUND(AVG(score), 2) AS ort_hepsi,
       ROUND(AVG(CASE WHEN is_empty THEN NULL ELSE score END), 2) AS ort_bos_haric
FROM ratings;

-- Q3: En az 30 puan vermiş puanlayıcılar (HAVING)
-- Soru: Yeterince puan vermiş puanlayıcılar kimler ve en yüksek ortalamayı kimler vermiş?
-- Beklenti: Puanlayıcıların büyük çoğunluğu 30 puan eşiğini geçecek.
-- Sonuç ve anlamı: En az 30 puan veren puanlayıcılar arasında ortalaması en yüksek 10 kişi, Q1'deki 10 kişiyle aynı (ortalama 89,9-100,0, her biri 35-65 puan vermiş). Yani bu uç ortalamalar birkaç puana dayanan tesadüfler değil, en az 35 puana dayanıyor.
SELECT rater_id,
       COUNT(*) AS puan_sayisi,
       ROUND(AVG(score), 1) AS ort_puan
FROM ratings
GROUP BY rater_id
HAVING COUNT(*) >= 30
ORDER BY ort_puan DESC
LIMIT 10;

-- Q4: Konuşma uzunluğuna göre short / medium / long sınıfları ve puan dağılımı (CASE WHEN)
-- Soru: Uzun konuşmalarda puanlar daha mı farklı?
-- Beklenti: Uzun konuşmalarda ortalama ve dağılım kısa konuşmalardan ayrışabilir.
-- Sonuç ve anlamı: Konuşma uzadıkça ortalama puan hafifçe artıyor (short 63,8; medium 64,8; long 66,8; short ile long arası 3,0 puan) ve standart sapma azalıyor (29,9; 29,5; 28,4). Fark küçük, puanlar her uzunlukta çok geniş dağılmış. Bu veriyle nedeni ayrılamaz; örneğin memnun kalan katılımcılar konuşmayı uzatmış olabilir.
SELECT CASE WHEN conversation_turns <= 2 THEN 'short'
            WHEN conversation_turns <= 4 THEN 'medium'
            ELSE 'long' END AS uzunluk,
       COUNT(*) AS puan_sayisi,
       ROUND(AVG(score), 1) AS ort_puan,
       ROUND(STDDEV(score), 1) AS puan_std
FROM ratings
GROUP BY 1
ORDER BY MIN(conversation_turns);

-- Q5: Haftalık ortalama ve ortanca puan (date_trunc)
-- Soru: Puanlar 5 haftalık dönem boyunca değişiyor mu?
-- Beklenti: Haftalar arasında büyük bir fark çıkmayacak.
-- Sonuç ve anlamı: İlk dört haftada ortalama 65,0 ile 66,1 arasında, ortanca 72 sabit. Puanların çoğu ilk iki haftada (25.191 ve 41.773 puan), sonraki haftalarda çok az (1.015; 155; 237). Son haftanın ortalaması 74,1 ve ortancası 83 ama yalnızca 237 puana dayanıyor, bu yüzden gerçek bir eğilim olarak yorumlanmamalı. Ortanca (72) ortalamanın yaklaşık 7 puan üstünde: düşük puanlar ortalamayı aşağı çekiyor.
SELECT date_trunc('week', rated_at)::date AS hafta,
       COUNT(*) AS puan_sayisi,
       ROUND(AVG(score), 1) AS ort_puan,
       ROUND(percentile_cont(0.5) WITHIN GROUP (ORDER BY score)::numeric, 1) AS ortanca
FROM ratings
GROUP BY 1
ORDER BY 1;

-- Q6 (ek): Konuşma türüne göre puan ortalaması ve dağılımı (ana soruya doğrudan cevap)
-- Soru: Puanların dağılımı hangi konuşma türünde daha geniş?
-- Beklenti: Tartışmalı konularda (controversy guided) dağılım daha geniş olabilir.
-- Sonuç ve anlamı: Üç konuşma türünde de standart sapma yaklaşık 28-30 puan, yani puanlar her türde çok geniş bir aralığa dağılıyor. En geniş dağılım unguided'da (29,9), en dar values guided'da (28,1), fark sadece 1,8 puan. Beklentimin aksine controversy guided en geniş dağılımlı tür değil, ama ortalaması en düşük (63,0; values guided'dan 3,8 puan düşük). Bu fark küçük olduğu için tek başına "tartışmalı konularda puanlar daha tutarsız" denemez.
SELECT conversation_type,
       COUNT(*) AS puan_sayisi,
       ROUND(AVG(score), 1) AS ort_puan,
       ROUND(STDDEV(score), 1) AS puan_std
FROM ratings
GROUP BY conversation_type
ORDER BY puan_std DESC;
