---
name: carfy
description: Carfy Servis layihəsi (C:\\Users\\bakht\\Desktop\\Carfy servis) — Telegram AI qeyd botu + Instagram DM lid sistemi: yeni müştəri qoşmaq, işə salmaq, debug etmək, alət əlavə etmək, VPS-ə deploy. Use when the user mentions Carfy, carfy botu, Telegram qeyd botu, Instagram DM lid, IG webhook, rəqib analizi (competitor), müştəri qoşmaq, clients/*.yaml, token.json/OAuth problemi, or errors from agent.py / bot.py / google_tools.py / ig_webhook.py / instagram.py.
---

# Carfy Servis

Kök: `C:\\Users\\bakht\\Desktop\\Carfy servis`
Çox-müştərili sistem: **hər müştəri = bir `clients/<ad>.yaml` + ayrı proses**. Kod hamı üçün eynidir.

İki ayrı proses var:

| Proses | İşə salma | Nə edir |
|---|---|---|
| Telegram bot | `python -m carfy --client <ad>` (və ya `run.bat <ad>`) | səs/yazı qeydi → Claude → Google Docs/Sheets |
| Instagram webhook | `python -m carfy.ig_webhook --client <ad>` | IG DM/rəy → lid analizi → Sheets |

Faydalı flaglar: `--verbose` (bot), `--port` / `--host` (webhook).

## ⚠️ README köhnəlmişdir

`README.md` service account yazır, **amma sistem OAuth istifadəçi girişinə keçmişdir**. `google_tools.py:53` məntiqi belədir:

- YAML-da `google_oauth_client_file` doldurulubsa → **OAuth** (istifadəçinin öz Google hesabı, `token.json`-da saxlanır, avtomatik yenilənir)
- boşdursa → service account (`google_service_account_file`)

**OAuth istifadə olunur, çünki service account öz adına yeni Google faylı yarada bilmir** (Drive kvotası yoxdur). Yeni müştəri qurarkən OAuth yolunu seç. Kök qovluqdaki `oauth_client.json` + `token.json` mövcud quraşdırmadır.

## Yeni müştəri qoşmaq

1. `clients/example.yaml` → `clients/<ad>.yaml` kopyala.
2. **Mütləq sahələr** (`carfy/config.py` → `ClientConfig`):
   - `client_name`, `telegram_bot_token` (@BotFather), `allowed_user_ids` (**boş qoyma** — hər kəs bota yaza bilər)
   - `anthropic_api_key`, `openai_api_key` (Whisper — səs qeydləri üçün)
   - `google_drive_folder_id`, `google_oauth_client_file`, `google_oauth_token_file`
   - `share_with_email` — yaradılan sənədləri müştəri görsün
3. İlk işə salma **lokalda** olsun: OAuth brauzer açır (`flow.run_local_server`). Serverdə brauzer yoxdur — token lokalda alınır, sonra köçürülür.
4. `run.bat <ad>` → Telegram-da `/start` ilə yoxla, sonra bir səsli qeyd göndər (Whisper axını da test olunsun).
5. Instagram hissəsi lazımdırsa aşağıdaki bölməyə keç. Lazım deyilsə IG sahələrini boş qoy — sistem onsuz da işləyir.

**Yollar** `config.py`-də layihə kökünə görə avtomatik tam yola çevrilir — YAML-a nisbi yol yazmaq normaldır.

## Instagram DM / lid sistemi

Konfiqdə 3 fərqli rejim var, prioritet belədir:

1. `webinar_info` doludursa → **kampaniya rejimi** (vebinar postuna rəy yazana bu mesaj gedir). Kampaniya bitəndə **boş qoy**, yoxsa normal cavab işləməyəcək.
2. `instagram_knowledge` doludursa → Claude bu bazaya əsasən **fərdi** cavab yazır, bazada olmayana cavab vermir.
3. Yalnız `instagram_auto_reply` varsa → sabit mesaj.

Digər sahələr: `instagram_page_token`, `instagram_app_secret`, `instagram_verify_token`, `instagram_webhook_port` (**hər müştəriyə fərqli port**), `instagram_leads_sheet`, `instagram_comment_keyword`, `instagram_comment_reply`, `webinar_post_id`.

Rəqib analizi (`competitor.py`, `ig_competitor_job.py`): `instagram_discovery_token`, `instagram_business_id`, `competitor_usernames`, `competitor_top_n`, `competitor_lookback_days`, `competitor_sheet`, `competitor_plan_doc`.

Webhook **HTTPS + doğrulanmış domen** tələb edir — lokal PC-də Meta ilə işləməz. Test üçün tunel (ngrok/cloudflared), canlı üçün deploy lazımdır.

## Yeni alət əlavə etmək

Botun bacarıqları `carfy/agent.py`-dəki `TOOLS` siyahısındadır (`list_files`, `append_to_document`, `create_document`, `read_document`, `append_to_sheet`, `create_spreadsheet`, `read_sheet`, `delete_sheet_row`, `delete_document_text`, `ig_dm_stats`).

Əlavə etmək üçün:

1. `TOOLS`-a Anthropic alət sxemi əlavə et (`name`, `description`, `input_schema`) — təsvir **azərbaycanca və konkret** olsun, model onunla qərar verir.
2. Faktiki işi görən funksiyanı `google_tools.py`-də (`GoogleWorkspace` metodu kimi) yaz.
3. `agent.py`-də alət adını icra funksiyasına bağla.
4. **Yeni Google scope lazımdırsa** (məs. Calendar) `google_tools.py:15` `SCOPES`-a əlavə et **və `token.json`-u sil** — köhnə token yeni icazəni daşımır, yenidən OAuth girişi lazımdır. Bu, ən çox yaddan çıxan addımdır.
5. Lokalda test et, sonra serverdə `token.json`-u yenilə.

## Debug ardıcıllığı

| Simptom | Yoxla |
|---|---|
| Bot cavab vermir | proses işləyirmi; `allowed_user_ids`-də sənin ID-n varmı; `telegram_bot_token` düzgündürmü; başqa yerdə həmin bot işləyirsə Telegram konflikt verir |
| «Konfiq tapılmadı» | `clients/<ad>.yaml` adı `--client` dəyəri ilə eyni olmalıdır |
| Google əməliyyatı 403 / permission | OAuth hesabı həmin qovluğa çıxışa malikdirmi; `google_drive_folder_id` düzgündürmü; scope çatırmı |
| `invalid_grant` / token xətası | `token.json` etibarsızdır → sil, lokalda yenidən OAuth keç, faylı serverə köçür |
| Yeni sənəd yaradılmır | service account rejimindəsən (Drive kvotası yox) → OAuth-a keç |
| Səs qeydi işləmir | `openai_api_key`, `transcribe.py`, fayl formatı |
| IG webhook boşdur | Meta-da `messages` sahəsinə abunəlik; `instagram_verify_token` uyğunluğu; HTTPS sertifikatı; `instagram_app_secret` ilə imza yoxlanması |
| IG cavabı səhv məzmundadır | rejim prioritetini yoxla — `webinar_info` boş qalıbmı |

Log: lokalda `--verbose`, serverdə `journalctl -u carfy-bot@<ad> -f`.

## Deploy

**Faktiki vəziyyət (2026-07-19 tarixinə):** sistem artıq **Hetzner VPS**-də işləyir — `/opt/carfy`, venv `/opt/carfy/venv`, sahibi `carfy` istifadəçisi. SSH açarı ilə `root` kimi girilir. Telegram botu **`carfy-bot@example` aktivdir**. Instagram webhook servisi (`carfy-ig@example`) **quraşdırılıb, amma başlatılmayıb** — domen, Caddy və Meta app tamamlanmalıdır. Serverə toxunmazdan əvvəl vəziyyəti `systemctl status` ilə **yenidən yoxla**, bu qeydə güvənib addım atma.

Kod dəyişikliyini serverə çıxarmaq: dəyişən faylları `scp` → `chown carfy:carfy` → `systemctl restart carfy-bot@example`.

**Python 3.14 qeydi:** serverdə Python 3.14 var; python-telegram-bot 21.x `asyncio.get_event_loop()` səbəbindən çökürdü. Düzəliş `carfy/bot.py` → `run()` içindədir (get_event_loop / except RuntimeError → yeni loop). Bu faylı dəyişəndə həmin düzəlişi silmə.

`deploy/` qovluğu hazırdır: `setup.sh`, `carfy-bot@.service`, `carfy-ig@.service`, `Caddyfile`, `caddy.service`, `privacy.html`, `DEPLOY.md`.

Qısa yol: `bash setup.sh` → faylları `scp` ilə `/opt/carfy`-ə (gizli fayllar daxil) → venv + pip → service faylları kopyala → `systemctl enable --now carfy-bot@<ad>` və `carfy-ig@<ad>` → Caddyfile-da domen → Meta webhook URL.

Yeni müştəri serverdə: YAML + **fərqli `instagram_webhook_port`** + iki `systemctl enable --now` + Caddyfile-a yol → `systemctl reload caddy`.

Ətraflı addımlar `deploy/DEPLOY.md`-dədir — **əvvəlcə onu oxu**, buradaki xülasəyə güvənib addım uydurma. Ümumi server qaydaları üçün `vps-deploy` skilinə bax.

## Təhlükəsizlik

- `clients/`, `token.json`, `oauth_client.json`, `Shahinsheet.json`, `*-service-account.json` — **gizlidir**. Söhbətə, hesabata, commit-ə, ekran görüntüsünə çıxarma. Yalnız "var/yoxdur" kimi yoxla.
- Müştərilər bir-birindən təcriddə: hər müştəri öz açarları və öz qovluğu ilə. Bunu qarışdırma.
- Log-a token və müştəri şəxsi məlumatı yazma.
- Müştəri sənədində/cədvəlində **silmə əməliyyatından əvvəl** (`delete_sheet_row`, `delete_document_text`) nəyin silindiyini göstər və təsdiq al.

## Satış / təhvil

Quraşdırma haqqı + aylıq abunə modeli. Ən yaxşı variant: **müştəri öz API açarlarını verir** — API xərci sənin üzərinə düşmür. Hesabat/təklif sənədi lazımdırsa `client-report` skilinə keç.
