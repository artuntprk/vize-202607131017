# Veri Kartı: PRISM Alignment Dataset

## Kaynak
- **Veri seti:** The PRISM Alignment Dataset
- **Yazarlar:** Hannah Rose Kirk, Alexander Whitefield, Paul Röttger, Andrew Bean ve diğerleri (University of Oxford ve ortak kurumlar)
- **Yayın:** NeurIPS 2024, Datasets and Benchmarks Track
- **Erişim:** https://huggingface.co/datasets/HannahRoseKirk/prism-alignment
- **DOI:** 10.57967/hf/2113

## Veri setinin amacı
PRISM, büyük dil modellerinin (LLM) insan tercihleriyle uyumlandırılması için toplanmış, kültürel olarak çeşitli bir insan geri bildirimi veri setidir. 1.500 katılımcı önce bir anketi dolduruyor, sonra 21 farklı LLM ile canlı konuşmalar yapıp model cevaplarını puanlıyor.

## Dosyalar ve satır sayıları
| Dosya | Satır sayısı | İçeriği |
|---|---|---|
| survey.jsonl | 1.500 | Her satır bir katılımcının anket cevapları (user_id ile tanımlı) |
| conversations.jsonl | 8.011 | Her satır bir konuşma (conversation_id, user_id ile anketle eşleşir) |
| utterances.jsonl | 68.371 | Her satır tek bir puanlanmış ifade: insan girdisi - model cevabı - puan |

## Senaryoyla ilişkisi
Bu projede senaryo, bir eğitim kurumunun sohbet asistanı cevaplarını birden fazla değerlendiricinin puanladığı ve puanlayıcılar arası tutarlılığın incelendiği bir durumu tarif ediyor. PRISM'deki utterances.jsonl dosyası, aynı mantıkla her bir model cevabına katılımcılar tarafından verilmiş puanları içeriyor; bu nedenle "puanlayıcılar arası tutarlılık" sorusunu incelemeye uygun.

**Not:** PRISM'deki puanlayıcılar (participants) öğretmen değil, genel halktan 1.500 katılımcıdır. Bu veri seti eğitim kurumlarına özgü gerçek bir puanlama sistemi değildir; senaryodaki "öğretmenler" rolü PRISM'in puanlayıcı katılımcılarıyla temsili olarak eşleştirilmiştir.

## Lisans
- İnsan tarafından yazılmış metinler (sorular/istemler dahil): Creative Commons Attribution 4.0 International (CC-BY-4.0)
- Model cevapları: Creative Commons Attribution-NonCommercial 4.0 International (CC-BY-NC-4.0), ayrıca ilgili modeli sağlayan şirketin kendi lisans şartlarına da uyulmalı
- Veri seti araştırma ve eğitim amaçlı kullanım için sağlanmıştır

## Veri üzerinde yapılan değişiklik
Ham veri (survey.jsonl, conversations.jsonl, utterances.jsonl) hiçbir değişiklik yapılmadan, orijinal hâliyle data/raw/ klasörüne kaydedilmiştir.