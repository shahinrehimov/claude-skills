---
name: client-report
description: Müştəri üçün layihə hesabatı, təklif (proposal) və təhvil sənədi hazırlamaq — Azərbaycan dilində, markdown/docx. Use when the user asks for a müştəri hesabatı, layihə hesabatı, təklif, proposal, qiymət təklifi, təhvil-təslim sənədi, project report, or documentation to hand a built system over to a client.
---

# Müştəri sənədləri

Nümunə: `C:\\Users\\bakht\\Desktop\\Carfy servis\\Carfy Servis — Layihə Hesabatı.docx` — yeni hesabat yazmazdan əvvəl mövcud sənədə bax və başlıq/ton üslubunu təkrarla.

Dil: **Azərbaycan dili**, texniki olmayan müştəri üçün anlaşılan. Kod detalları yalnız "Texniki qeydlər" bölməsində.

## Layihə hesabatı strukturu

```
# <Layihə adı> — Layihə Hesabatı
Tarix | Hazırladı | Versiya

## 1. Xülasə
2-3 cümlə: nə quruldu, hansı problemi həll edir.

## 2. Nə edilib
Bölmə-bölmə, hər biri 1-2 sətir. Nəticə dilində yaz ("müştəri sorğusu avtomatik cədvələ düşür"),
texnologiya dilində yox ("Google Sheets API v4 integrasiyası").

## 3. Necə işləyir
Sadə axın: giriş → emal → nəticə. Sxem lazımsa mermaid diaqram.

## 4. Nə lazımdır (müştəri tərəfi)
Hesablar, açarlar, aylıq xərclər, kimin nəyə çıxışı var.

## 5. Aylıq xərclər
Cədvəl: xidmət | təyinat | təxmini aylıq məbləğ. Bilmədiyin qiyməti uydurma.

## 6. Növbəti mərhələ
Hazırda YOXDUR olan, sonra əlavə oluna bilən şeylər.

## 7. Texniki qeydlər
Repo yolu, işə salma əmri, konfiqurasiya faylları, log yerləri.
```

## Təklif (proposal) strukturu

```
## Problem            — müştərinin öz sözləri ilə
## Həll               — nə quracam
## Əhatə (daxildir)   — konkret siyahı
## Əhatəyə daxil deyil — sərhədi burada çək, sonrakı mübahisələr buradan çıxır
## Mərhələlər və müddət
## Qiymət             — quraşdırma + aylıq
## Şərtlər            — ödəniş qrafiki, dəstək müddəti, kimin hansı hesabı verir
```

**"Əhatəyə daxil deyil" bölməsini heç vaxt atlamaq olmaz.** Layihələr orada yazılmayan işlərdən uzanır.

## Qaydalar

- **Rəqəm uydurma.** Qiymət, müddət, istifadəçi sayı, nəticə faizi — istifadəçidən soruş və ya "təxmini/dəqiqləşdirilməli" kimi işarələ.
- **Sirləri sənədə yazma.** API açarı, token, parol, `.env` məzmunu müştəri sənədinə düşməməlidir — "açar ayrıca təhlükəsiz kanalla verilir" yaz.
- Cümlələr qısa olsun. Hər bölmə ekranda bir baxışda oxunmalıdır.
- Şəkil/ekran görüntüsü yeri lazımdırsa `[EKRAN GÖRÜNTÜSÜ: bot cavabı]` kimi yer saxla — istifadəçi sonra əlavə edər.

## Fayl formatı

Əvvəlcə **markdown** yaz (`.md`) — redaktə etmək asandır. Sonra istifadəçi hansını istəyir:

- **docx** lazımdırsa: pandoc varsa `pandoc hesabat.md -o hesabat.docx`; yoxdursa markdown-u Word-ə köçürməyi təklif et.
- **Müştəriyə göstərmək / link paylaşmaq** lazımdırsa Artifact kimi dərc etməyi təklif et — səliqəli, brauzerdə açılan səhifə olur.

Hazır sənədi layihənin öz qovluğunda saxla (məs. `Desktop\\<Layihə>\\`), scratchpad-də qoyub getmə.
