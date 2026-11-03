-- Vize Hafta 5 sorgulari (Kura #18). Tablo: ratings, raters (bkz. scripts/build_ratings.py)

-- Q1: Puanlayici basina puan sayisi ve ortalama, genel ortalamadan farkla (GROUP BY, ROUND)
-- Soru: Hangi puanlayicilar genel ortalamadan en cok sapıyor?
-- Beklenti: Bazi puanlayicilar belirgin bicimde sert ya da comert cikacak.
-- Sonuc ve anlami: Genel ortalama 65,13. Genel ortalamadan en cok yukari sapan 10 puanlayicinin ortalamasi 89,9 ile 100,0 arasinda, farklar +24,8 ile +34,9 puan. user186 (40 puan) ve user1270 (35 puan) ortalamasi 100,0, yani hemen hemen butun puanlari 100. Bu kisiler cok comert olabilir ya da puanlari ayirt etmeden vermis olabilir, bu sorgu ikisini ayiramaz. Sorgu yalnizca en comert ucu gosteriyor.

SELECT rater_id,
       COUNT(*) AS puan_sayisi,
       ROUND(AVG(score), 1) AS ort_puan,
       ROUND(AVG(score) - (SELECT AVG(score) FROM ratings), 1) AS genel_ort_farki
FROM ratings
GROUP BY rater_id
ORDER BY genel_ort_farki DESC
LIMIT 10;


-- Q2: Olcek disi puan ve bos model cevabi sayisi; bos cevaplar cikarilinca ortalamanin degisimi (FILTER, CASE WHEN)
-- Soru: 1-100 disinda puan var mi ve bos cevaplar ortalamayi ne kadar cekiyor?
-- Beklenti: Olcek disi puan yok; bos cevaplar ortalamayi biraz asagi cekiyor.
-- Sonuc ve anlami: Olcek disi (1-100 disi) puan yok. 147 bos model cevabi var (68.371 puanin yaklasik %0,2'si). Bos cevaplar dahil ortalama 65,13, haric 65,25, fark yalnizca 0,12 puan. Bos cevaplar sayica az oldugu icin ortalamayi neredeyse etkilemiyor; yine de silinmedi, ayri raporlandi.

SELECT COUNT(*) FILTER (WHERE score < 1 OR score > 100) AS olcek_disi,
       COUNT(*) FILTER (WHERE is_empty) AS bos_cevap,
       ROUND(AVG(score), 2) AS ort_hepsi,
       ROUND(AVG(CASE WHEN is_empty THEN NULL ELSE score END), 2) AS ort_bos_haric
FROM ratings;

-- Ek kontrol: olcek disi puanlari NULL'a cevirsek ortalama nasil degisirdi? (yonerge soru 2)
SELECT ROUND(AVG(score), 2) AS ort_orijinal,
       ROUND(AVG(CASE WHEN score < 1 OR score > 100 THEN NULL ELSE score END), 2) AS ort_null_cevirince
FROM ratings;
-- Sonuc: ort_orijinal = 65.13, ort_null_cevirince = 65.13, fark yok. Veride olcek disi (1-100 disi) puan olmadigi icin NULL'a cevirmenin ortalamaya hicbir etkisi olmuyor; bu kontrol, Q2'deki "olcek disi puan: 0" bulgusunu dogruluyor.


-- Q3: En az 30 puan vermis puanlayicilar (HAVING)
-- Soru: Yeterince puan vermis puanlayicilar kimler ve en yuksek ortalamayi kimler vermis?
-- Beklenti: Puanlayicilarin buyuk cogunlugu 30 puan esigini gececek.
-- Sonuc ve anlami: En az 30 puan veren puanlayicilar arasinda ortalamasi en yuksek 10 kisi, Q1'deki 10 kisiyle ayni (ortalama 89,9-100,0, her biri 35-65 puan vermis). Yani bu uc ortalamalar birkac puana dayanan tesadufler degil, en az 35 puana dayaniyor.

SELECT rater_id,
       COUNT(*) AS puan_sayisi,
       ROUND(AVG(score), 1) AS ort_puan
FROM ratings
GROUP BY rater_id
HAVING COUNT(*) >= 30
ORDER BY ort_puan DESC
LIMIT 10;


-- Q4: Konusma uzunluguna gore short / medium / long siniflari ve puan dagilimi (CASE WHEN)
-- Soru: Uzun konusmalarda puanlar daha mi farkli?
-- Beklenti: Uzun konusmalarda ortalama ve dagilim kisa konusmalardan ayrisabilir.
-- Sonuc ve anlami: Konusma uzadikca ortalama puan hafifce artiyor (short 63,8; medium 64,8; long 66,8; short ile long arasi 3,0 puan) ve standart sapma azaliyor (29,9; 29,5; 28,4). Fark kucuk, puanlar her uzunlukta cok genis dagilmis. Bu veriyle nedeni ayrilamaz; ornegin memnun kalan katilimcilar konusmayi uzatmis olabilir.

SELECT CASE WHEN conversation_turns <= 2 THEN 'short'
            WHEN conversation_turns <= 4 THEN 'medium'
            ELSE 'long' END AS uzunluk,
       COUNT(*) AS puan_sayisi,
       ROUND(AVG(score), 1) AS ort_puan,
       ROUND(STDDEV(score), 1) AS puan_std
FROM ratings
GROUP BY 1
ORDER BY MIN(conversation_turns);


-- Q5: Haftalik ortalama ve ortanca puan (date_trunc)
-- Soru: Puanlar 5 haftalik donem boyunca degisiyor mu?
-- Beklenti: Haftalar arasinda buyuk bir fark cikmayacak.
-- Sonuc ve anlami: Ilk dort haftada ortalama 65,0 ile 66,1 arasinda, ortanca 72 sabit. Puanlarin cogu ilk iki haftada (25.191 ve 41.773 puan), sonraki haftalarda cok az (1.015; 155; 237). Son haftanin ortalamasi 74,1 ve ortancasi 83 ama yalnizca 237 puana dayaniyor, bu yuzden gercek bir egilim olarak yorumlanmamali. Ortanca (72) ortalamanin yaklasik 7 puan ustunde: dusuk puanlar ortalamayi asagi cekiyor.

SELECT date_trunc('week', rated_at)::date AS hafta,
       COUNT(*) AS puan_sayisi,
       ROUND(AVG(score), 1) AS ort_puan,
       ROUND(percentile_cont(0.5) WITHIN GROUP (ORDER BY score)::numeric, 1) AS ortanca
FROM ratings
GROUP BY 1
ORDER BY 1;


-- Q6 (ek): Konusma turune gore puan ortalamasi ve dagilimi (ana soruya dogrudan cevap)
-- Soru: Puanlarin dagilimi hangi konusma turunde daha genis?
-- Beklenti: Tartismali konularda (controversy guided) dagilim daha genis olabilir.
-- Sonuc ve anlami: Uc konusma turunde de standart sapma yaklasik 28-30 puan, yani puanlar her turde cok genis bir araliga dagiliyor. En genis dagilim unguided'da (29,9), en dar values guided'da (28,1), fark sadece 1,8 puan. Beklentimin aksine controversy guided en genis dagilimli tur degil, ama ortalamasi en dusuk (63,0; values guided'dan 3,8 puan dusuk). Bu fark kucuk oldugu icin tek basina "tartismali konularda puanlar daha tutarsiz" denemez.

SELECT conversation_type,
       COUNT(*) AS puan_sayisi,
       ROUND(AVG(score), 1) AS ort_puan,
       ROUND(STDDEV(score), 1) AS puan_std
FROM ratings
GROUP BY conversation_type
ORDER BY puan_std DESC;