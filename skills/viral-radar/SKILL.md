---
name: viral-radar
description: Pixenzz Viral Radar (C:\\Users\\bakht\\pixenzz-viral-radar) layihəsini işlətmək, günlük axını yoxlamaq və debug etmək. Use when the user mentions viral radar, pixenzz, viral content research, günlük viral hesabat, YouTube trending / Apify Instagram-TikTok scraping, Claude skorlama, Telegram hesabatı, or errors from main.py / collectors / scoring / delivery in that project.
---

# Pixenzz Viral Radar — işlətmə və debug

Layihə kökü: `C:\\Users\\bakht\\pixenzz-viral-radar`
Axın: **topla → normallaşdır → skorla (Claude) → kateqoriyala → yadda saxla → hesabat → Telegram**

## Əvvəlcə bunu et

Həmişə layihənin `.venv`-ini istifadə et, qlobal python-u yox:

```powershell
C:\\Users\\bakht\\pixenzz-viral-radar\\.venv\\Scripts\\python.exe main.py --dry-run
```

`cd` etmək lazımdırsa PowerShell tool-unda `Set-Location` ilə et — `config.py` `.env`-i cari qovluqdan oxuyur, ona görə əmrləri **layihə kökündən** işlət.

## Əmrlər

| Məqsəd | Əmr |
|---|---|
| Offline smoke-test (API açarı lazım deyil) | `python selftest.py` |
| Konfiqurasiya yoxlaması | `python check_setup.py` |
| Tam axın, Telegram-a göndər | `python main.py` |
| Test — Telegram-a göndərmə, ekrana çıxar | `python main.py --dry-run` |
| Sürətli test — Claude skorlamasını atla | `python main.py --no-score --dry-run` |
| Davamlı planlayıcı (hər gün `RUN_AT`) | `python main.py --schedule` |

Dəyişiklik etdikdən sonra **əvvəlcə `--dry-run --no-score`** ilə yoxla — belə həm Telegram-a zibil mesaj getmir, həm Anthropic krediti yanmır.

## Konfiqurasiya (.env)

`config.py` bütün ayarları `.env`-dən oxuyur. Vacib açarlar:

- `ANTHROPIC_API_KEY`, `CLAUDE_MODEL`, `CLAUDE_REPORT_MODEL` — skorlama və hesabat
- `YOUTUBE_API_KEY`, `YOUTUBE_REGION` (default `AZ`)
- `APIFY_TOKEN`, `IG_HASHTAGS`, `TIKTOK_HASHTAGS`, `APIFY_IG_ACTOR`, `APIFY_TIKTOK_ACTOR`
- `MAX_ITEMS_PER_SOURCE` (25), `MIN_VIEWS` (5000), `TOP_N` (5)
- `TELEGRAM_BOT_TOKEN`, `TELEGRAM_CHAT_ID`
- `GOOGLE_SHEETS_ID`, `GOOGLE_SERVICE_ACCOUNT_JSON`, `STORAGE_DIR` (`data`), `RUN_AT` (`08:00`)

**`.env` faylını heç vaxt oxunan çıxışa, hesabata, commit-ə və ya söhbətə tam şəkildə çıxarma.** Açar lazımdırsa yalnız "var / yoxdur" kimi yoxla.

## Debug ardıcıllığı

Xəta gələndə mərhələ-mərhələ dar:

1. **`0 xam element`** → collector problemi. `src/collectors/youtube.py` (API açarı, kvota, region) və `src/collectors/apify_sources.py` (actor adı, token, hashtag boşdur?) yoxla. Apify actor-ları ödənişlidir — token limiti bitmiş ola bilər.
2. **`N xam → 0 təmiz`** → `src/normalize.py`-də `MIN_VIEWS` çox yüksəkdir və ya sahə adları dəyişib (Apify actor-un output sxemi dəyişə bilir).
3. **Skorlama xətası** → `src/scoring.py`. Model adı `.env`-də düzgündürmü (`claude-sonnet-5`), Anthropic key aktivdirmi, JSON parse xətasıdırsa Claude cavabı sxemə uymayıb.
4. **Sheets xətası** → `src/storage.py`. Service account faylı var? Sheet həmin service account e-poçtu ilə paylaşılıb?
5. **Telegram xətası** → `src/delivery.py`. `chat_id` düzgün? Bot həmin çata əlavə edilib? Mesaj 4096 simvoldan uzundur?

Lokal nəticələr `data/YYYY-MM-DD.json`-da saxlanılır — dünənki fayla baxmaq "əvvəl işləyirdi?" sualına ən tez cavabdır.

## n8n variantı

`n8n/pixenzz-viral-radar.workflow.json` eyni axının n8n qarşılığıdır. Python tərəfdə məntiq dəyişəndə soruş: n8n workflow-u da sinxronlaşdırmaq lazımdır? İkisi ayrı düşərsə debug çətinləşir.
