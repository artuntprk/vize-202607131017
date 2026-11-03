# Veri Karti

## Kaynak
- Veri seti: PRISM Alignment Dataset
- Yazar: Hannah Rose Kirk ve ekibi (Oxford Internet Institute)
- Adres: https://huggingface.co/datasets/HannahRoseKirk/prism-alignment
- Indirme tarihi: 31.10.2026
- Makale: arXiv:2404.16019

## Lisans
- Insan yazilari (acik geri bildirim metinleri dahil): CC BY 4.0
- Model yanitlari: CC BY-NC 4.0
- Odev kapsaminda ticari olmayan egitim amacli kullanilmaktadir.

## Dosyalar ve boyutlar (data/raw/)
| Dosya | Satir | Sutun | Aciklama |
|---|---|---|---|
| utterances.jsonl | 68.371 | 14 | Her bir model yanitina verilen puan |
| conversations.jsonl | 8.011 | 13 | Konusma basliklari, tarih/saat, sure |
| survey.jsonl | 1.500 | 32 | Puanlayicilarin anket cevaplari |

## Senaryo ile farklar
Hoca senaryosu (Kura #18) dil okulunda ogretmenlerin 1-5 arasi puan verdigi bir
sistemi tarif ediyor. Hikaye SCENARIO.md'de aynen korunmustur. Kullanilan veri
setinde su farklar vardir:
- Puanlayicilar ogretmen degil, 75 ulkeden 1.500 arastirma katilimcisidir.
- Konusmalar dil egitimiyle sinirli degildir (unguided, values guided,
  controversy guided olmak uzere 3 tur).
- Ham puan 1-100 arasi kayan cubuk skorudur; sql/hafta-05.sql'in de girdisi
  olan data/processed/ratings.csv dosyasinda score_1_5 adiyla 1-5 olcegine
  donusturulmustur ((score-1)//20+1 formuluyle).
- raters tablosunda experience_years yerine survey.jsonl'deki
  lm_familiarity ve lm_frequency_use (yapay zeka araclarina asinalik ve
  kullanim sikligi) sutunlari kullanilmistir.

Bu konuda hocaya 31.10.2026 tarihinde e-posta ile soru soruldu, [cevap
bekleniyor / onaylandi - cevaba gore doldurulacak].

## Yuklenmeyen sutunlar
survey.jsonl icindeki religion, ethnicity, location, gender, self_description,
marital_status gibi kisisel/demografik sutunlar veritabanina yuklenmemistir;
odevin analiz sorulariyla ilgisi yoktur.

## Temizlik ve donusturme adimlari
1. Ham dosyalar (data/raw/) hic degistirilmeden saklanmistir.
2. scripts/load_data.py ham dosyalari oldugu gibi PostgreSQL'e yukler.
3. scripts/build_ratings.py su donusturmeleri yapar ve data/processed/
   altina ayri CSV olarak kaydeder:
   - utterances ve conversations tablolari conversation_id uzerinden
     birlestirilir (conversation_turns ve generated_datetime eklenir).
   - generated_datetime metin (text) tipinden timestamp'e cevrilir
     (rated_at sutunu).
   - score sutunundan score_1_5 (1-5 olcek) turetilir.
   - model_response alani "EMPTY STRING" olan satirlar is_empty=true
     olarak isaretlenir, silinmez.

## Veri tuzaklari (Hafta 4)
- 147 satirda (yaklasik %0,2) model_response "EMPTY STRING" olarak
  kaydedilmis; bunlara verilen puanlarin ortalamasi 11,9, genel ortalama
  65,1. Bu satirlar silinmemis, is_empty sutunuyla ayri isaretlenmistir.
- generated_datetime sutunu ham dosyada metin (text) olarak saklanmis,
  sorgularda ::timestamp ile donusturulmustur.
- Puanlama tarihleri 22 Kasim - 22 Aralik 2023 arasinda yogunlasmis;
  son iki hafta cok az satir iceriyor (155 ve 237), bu yuzden o haftalarin
  ortalamalari az sayiya dayaniyor ve veri kartinda ayrica belirtilmistir.