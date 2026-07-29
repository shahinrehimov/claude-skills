---
name: ffmpeg-video
description: ffmpeg ilə video kəsmə, 9:16 çevirmə, sıxma, səs çıxarma, altyazı yandırma, birləşdirmə, GIF və kadr çıxarma. Use when the user wants to trim/cut video, convert aspect ratio (9:16, 1:1, 16:9) for reels, compress a large mp4, extract audio, burn subtitles, merge clips, make a thumbnail/frame grab, change fps or resolution, or fix a file that won't upload.
---

# ffmpeg əməliyyatları

Windows/PowerShell mühiti. Fayl adlarında boşluq var (`insta video 2.mp4`) — **yolları həmişə dırnaq içində** ver.

## Vacib qaydalar

- **Mənbə faylın üzərinə yazma.** Çıxışı yeni ada yaz (`_out`, `_916`, `_small` şəkilçisi). ffmpeg input=output olanda faylı korlayır.
- Əməliyyatdan əvvəl faylı analiz et:
  ```powershell
  ffprobe -v error -show_entries stream=width,height,r_frame_rate,codec_name,duration -of default=noprint_wrappers=1 "video.mp4"
  ```
- Uzun əməliyyatları `run_in_background: true` ilə işlət (4K sıxma dəqiqələr çəkə bilər).
- `ffmpeg` PATH-də yoxdursa `(Get-Command ffmpeg).Source` ilə yoxla; yoxdursa qurulmasını təklif et (`winget install Gyan.FFmpeg`).

## Kəsmə (ən sürətli, yenidən kodlaşdırmadan)

```powershell
ffmpeg -ss 00:00:05 -to 00:00:23 -i "giris.mp4" -c copy "cixis.mp4"
```

`-c copy` keyfiyyəti qoruyur amma yalnız keyframe-lərdə dəqiq kəsir. **Kadr dəqiqliyi lazımdırsa** yenidən kodlaşdır:

```powershell
ffmpeg -ss 00:00:05 -to 00:00:23 -i "giris.mp4" -c:v libx264 -crf 18 -c:a aac "cixis.mp4"
```

## 9:16 reels üçün çevirmə

**Kəsib doldurmaq (crop — mərkəzdən, ən çox işlənən):**

```powershell
ffmpeg -i "giris.mp4" -vf "scale=1080:-2:force_original_aspect_ratio=increase,crop=1080:1920" -c:v libx264 -crf 20 -c:a copy "cixis_916.mp4"
```

**Bulanıq fon üstündə saxlamaq (heç nə itmir):**

```powershell
ffmpeg -i "giris.mp4" -vf "scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2,boxblur=0" -c:v libx264 -crf 20 "cixis_916.mp4"
```

1:1 üçün `1080:1080`, 16:9 üçün `1920:1080` — eyni şablon.

## Sıxma (yükləmə limiti üçün)

```powershell
ffmpeg -i "boyuk.mp4" -c:v libx264 -crf 26 -preset slow -c:a aac -b:a 128k "kicik.mp4"
```

`crf`: 18 = yüksək keyfiyyət, 23 = balans, 28 = kiçik fayl. Instagram üçün 1080p + crf 23 kifayətdir. Hədəf ölçü lazımdırsa iki keçidli bitrate istifadə et.

## Səs

```powershell
ffmpeg -i "video.mp4" -vn -acodec libmp3lame -q:a 2 "ses.mp3"     # səs çıxar
ffmpeg -i "video.mp4" -an -c:v copy "sessiz.mp4"                  # səsi sil
ffmpeg -i "video.mp4" -i "musiqi.mp3" -c:v copy -map 0:v -map 1:a -shortest "cixis.mp4"  # musiqi əlavə et
```

## Altyazı

```powershell
ffmpeg -i "video.mp4" -vf "subtitles=altyazi.srt:force_style='FontName=Arial,FontSize=18,PrimaryColour=&Hffffff&,OutlineColour=&H80000000&,BorderStyle=3'" -c:a copy "cixis.mp4"
```

Azərbaycan hərfləri (ə, ğ, ı, ö, ş, ü) üçün `.srt` faylı **UTF-8** olmalıdır və şrift həmin hərfləri dəstəkləməlidir (Arial, Segoe UI olar).

## Birləşdirmə

Eyni kodek/ölçüdə olanlar üçün:

```powershell
"file 'C:\\yol\\bir.mp4'`nfile 'C:\\yol\\iki.mp4'" | Out-File -Encoding utf8 list.txt
ffmpeg -f concat -safe 0 -i list.txt -c copy "birlesmis.mp4"
```

Fərqli ölçü/kodekdirsə əvvəlcə hamısını eyni formata çevir, sonra birləşdir.

## Kadr / GIF / thumbnail

```powershell
ffmpeg -ss 00:00:03 -i "video.mp4" -frames:v 1 -q:v 2 "kadr.jpg"
ffmpeg -ss 00:00:02 -t 4 -i "video.mp4" -vf "fps=15,scale=480:-1" -loop 0 "cixis.gif"
```

## fps və sürət

```powershell
ffmpeg -i "video.mp4" -filter:v "setpts=0.5*PTS" -filter:a "atempo=2.0" "iki_qat.mp4"   # 2x sürət
ffmpeg -i "video.mp4" -r 30 -c:v libx264 -crf 20 "30fps.mp4"
```

## Sosial şəbəkə üçün təhlükəsiz profil

Yüklənməyən fayl olanda bu "hər yerdə işləyən" profilə çevir:

```powershell
ffmpeg -i "giris.mp4" -c:v libx264 -profile:v high -pix_fmt yuv420p -crf 21 -c:a aac -b:a 128k -movflags +faststart "cixis.mp4"
```

`-pix_fmt yuv420p` və `+faststart` Instagram/TikTok yükləmə xətalarının ən çox rast gəlinən həllidir.
