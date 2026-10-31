# AI_BEYAN.md

Bu ödevde Claude (Anthropic) adli bir yapay zeka asistanindan asagidaki
konularda yardim alinmistir:

1. Ortam kurulumu: GitHub reposunun olusturulmasi, vize-teslim dalinin
   acilmasi, klasor yapisinin (data/raw, data/processed, sql, scripts)
   planlanmasi.
2. Veri seti arastirmasi: Senaryoya (Kura #18) uygun, puanlayici kimligi,
   puan ve tarih iceren, acik lisansli bir veri seti aranmasi ve
   adaylarin (PRISM, DICES-350) karsilastirilmasi.
3. Veri yukleme ve donusturme: PostgreSQL kurulumu (scripts icindeki
   load_data.py ve build_ratings.py betiklerinin yazilmasi), ham
   dosyalarin veritabanina yuklenmesi, ratings ve raters tablolarinin
   olusturulmasi.
4. SQL sorgulari: sql/hafta-05.sql icindeki 6 sorgunun (GROUP BY, FILTER,
   HAVING, CASE WHEN, date_trunc) yazilmasi; sorgu sonuclarinin
   yorumlanmasinda yardim alinmistir.
5. Dokumantasyon: data/README.md (veri karti) ve SCENARIO.md
   dosyalarinin metinlerinin yazilmasinda yardim alinmistir.

Tum SQL sorgulari ve yorumlari calistirilip dogrulanmis sonuclara
dayanmaktadir; veri uzerinde hicbir uydurma deger kullanilmamistir.# Yapay Zeka Beyanı