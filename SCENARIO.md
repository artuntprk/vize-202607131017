# SCENARIO.md

## Senaryo
Kura sonucu (Kura #18): Egitim x Sohbet asistani x Insan geri bildirimi ve puanlama.

Hikaye: Bir dil okulu ogrencilerin sohbet asistaniyla yaptigi konusmalari sonradan
ogretmenlere puanlatiyor. Puanlar asistanin bir sonraki surumunu gelistirmek icin
kullanilacak. Okul puanlayicilar arasindaki tutarliligi da olcmek istiyor.

## Ana soru
Puanlayicilar konusmalara ayni bicimde mi puan veriyor ve tutarsizlik hangi
konusma turunde yogunlasiyor?

## Problem
Sistemi gelistiren ekip, farkli puanlayicilarin ayni kalitedeki bir cevaba
birbirinden cok farkli puanlar verip vermedigini bilmiyor. Bazi puanlayicilar
sistematik olarak daha sert ya da daha comert olabilir; bu durum, puanlarin
asistanin gercek kalitesini mi yoksa puanlayicinin kendi egilimini mi
yansittigini belirsizlestiriyor. Bu calisma, puanlayicilar arasindaki
tutarliligi olcerek bu belirsizligi azaltmayi hedefliyor.

## Hedef kullanici
Sistemi gelistiren ekip (urun/kalite ekibi) ve dolayli olarak asistanin
cevaplarini kullanan ogrenciler.

## Veri kaynagi (kullanilan)
- PRISM Alignment Dataset (Hugging Face, CC BY 4.0 / CC BY-NC 4.0)
- Detay ve senaryo ile farklar icin bkz. data/README.md

## Tablo adaylari
- conversations(id, topic, message_length, created_at)
- ratings(id, conversation_id, rater_id, score_1_5, rated_at)
- raters(id, experience_years)

Gercek veride kullanilan karsiliklari (bkz. scripts/build_ratings.py ve
data/README.md):
- ratings: id, conversation_id, rater_id, conversation_type, turn,
  within_turn_id, model_name, score (1-100 ham), score_1_5 (turetilmis),
  is_empty, conversation_turns, rated_at
- raters: rater_id, lm_familiarity, lm_frequency_use, lm_direct_use,
  num_completed_conversations (experience_years yerine)