-- Ödev 2, Bölüm 1: Filo soruları
-- Ad Soyad: Artun Toprak Dereli
-- Öğrenci No: 202607131017
-- Veritabanı: robot_fleet
-- Her sorgunun altına sonucu açıklayan tek cümlelik yorum yaz.

-- Soru 1: Her robotun adı, operatör adı ve operatör telefonu (INNER JOIN)
SELECT r.name AS robot_adi, r.operator_name AS operator_adi, o.phone AS telefon
FROM robots r
JOIN operators o ON r.operator_name = o.operator_name;

-- Yorum: Sorgu 9 satır döndürdü; Mars-03 listede yok çünkü operator_name alanı NULL, yani operators tablosunda eşleşen bir kayıt bulunamadı.


-- Soru 2: Aynı liste, bütün robotlar görünsün (LEFT JOIN). 1. sorguyla karşılaştır, kim kayboldu?
SELECT r.name AS robot_adi, r.operator_name AS operator_adi, o.phone AS telefon
FROM robots r
LEFT JOIN operators o ON r.operator_name = o.operator_name;

-- Yorum: LEFT JOIN ile 10 satır (tüm robotlar) döndü; Mars-03'ün operator_adi ve telefon sütunları boş çıktı çünkü bu robota hiç operatör atanmamış, bu yüzden 1. sorguda kaybolmuştu.


-- Soru 3: Hiç görev almamış robotların adı ve modeli
SELECT r.name AS robot_adi, r.model
FROM robots r
LEFT JOIN missions m ON m.robot_id = r.id
WHERE m.id IS NULL;

-- Yorum: 4 robot (Kartal-02, Kartal-04, Atlas-03, Mars-03) hiç görev almamış, çünkü missions tablosunda bu robotların id'lerine ait hiçbir kayıt yok.


-- Soru 4a: JOIN ile hesaplanan toplam batarya (görevi olan robotlar)
SELECT SUM(r.battery_level) AS toplam_batarya_join_ile
FROM robots r
JOIN missions m ON m.robot_id = r.id;

-- Soru 4b: JOIN kullanmadan doğru toplam
SELECT SUM(battery_level) AS toplam_batarya_dogru
FROM robots
WHERE id IN (SELECT DISTINCT robot_id FROM missions);

-- Yorum (iki sonuç ve fark): JOIN ile hesaplanan toplam 700, JOIN'siz doğru toplam ise 262 çıktı; fark, JOIN'in her görevi ayrı bir satır saymasından (fan-out) kaynaklanıyor - birden fazla görevi olan bir robotun batarya seviyesi, görev sayısı kadar tekrar tekrar toplanıyor.


-- Soru 5: Robot başına görev sayısı; count(*) ve count(m.id) yan yana
SELECT r.name AS robot_adi, COUNT(*) AS sayim_yildiz, COUNT(m.id) AS sayim_id
FROM robots r
LEFT JOIN missions m ON m.robot_id = r.id
GROUP BY r.name;

-- Yorum (hangi robotlarda ikisi farklı?): Hiç görev almamış dört robotta (Kartal-02, Kartal-04, Atlas-03, Mars-03) count(*) 1, count(m.id) ise 0 çıktı; çünkü LEFT JOIN eşleşmeyen satırı yine de bir satır olarak sayıyor ama m.id sütunu NULL olduğundan COUNT onu saymıyor.