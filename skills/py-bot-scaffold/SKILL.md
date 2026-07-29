---
name: py-bot-scaffold
description: Yeni Python avtomatizasiya botu/skripti üçün standart skelet qurmaq — .env + config.py, venv, logging, Telegram, Google Sheets, selftest. Use when the user wants to start a new bot, new automation, yeni layihə qurmaq, scaffold a Python script that talks to Telegram/Sheets/an API, or asks to set up the boilerplate before writing logic.
---

# Yeni Python avtomatizasiya layihəsi

Etalon: `C:\\Users\\bakht\\pixenzz-viral-radar` — struktur və üslub oradan götürülür. Yeni layihə də həmin şablona uysun ki, ikisini eyni cür debug etmək mümkün olsun.

## Struktur

```
<layihe-adi>/
├── main.py             # CLI orkestrasiya: --dry-run, --schedule
├── config.py           # bütün ayarlar .env-dən, dataclass Settings
├── selftest.py         # API açarı olmadan işləyən offline smoke-test
├── check_setup.py      # açarlar/qoşulmalar yerindədirmi
├── requirements.txt
├── .env.example        # açar ADLARI, dəyərlər YOX
├── .gitignore          # .env, token.json, *.json creds, .venv, __pycache__
├── README.md           # Azərbaycan dilində quraşdırma + işlətmə
├── src/
│   ├── __init__.py
│   ├── collectors/     # data mənbələri (hər mənbə ayrı fayl)
│   ├── normalize.py
│   ├── storage.py      # lokal JSON + Sheets
│   └── delivery.py     # Telegram/e-poçt
└── data/               # nəticələr: YYYY-MM-DD.json
```

## Qurulma addımları

```powershell
New-Item -ItemType Directory -Force "C:\\Users\\bakht\\Desktop\\<layihe-adi>"
python -m venv .venv
.venv\\Scripts\\python.exe -m pip install -r requirements.txt
```

Bütün əmrləri **layihənin `.venv`-i ilə** işlət, qlobal `python` ilə yox.

## config.py şablonu

```python
"""Mərkəzi konfiqurasiya — bütün ayarlar .env faylından yüklənir."""
from __future__ import annotations
import os
from dataclasses import dataclass, field

try:
    from dotenv import load_dotenv
    load_dotenv()
except ImportError:
    pass

def _int(name: str, default: int) -> int:
    try:
        return int(os.getenv(name, str(default)))
    except (TypeError, ValueError):
        return default

@dataclass
class Settings:
    anthropic_api_key: str = field(default_factory=lambda: os.getenv("ANTHROPIC_API_KEY", ""))
    claude_model: str = field(default_factory=lambda: os.getenv("CLAUDE_MODEL", "claude-sonnet-5"))
    telegram_bot_token: str = field(default_factory=lambda: os.getenv("TELEGRAM_BOT_TOKEN", ""))
    telegram_chat_id: str = field(default_factory=lambda: os.getenv("TELEGRAM_CHAT_ID", ""))
    run_at: str = field(default_factory=lambda: os.getenv("RUN_AT", "08:00"))
    storage_dir: str = field(default_factory=lambda: os.getenv("STORAGE_DIR", "data"))

settings = Settings()
```

## main.py qaydaları

- `argparse` ilə mütləq **`--dry-run`** (heç nə göndərmə, ekrana çıxar) olsun.
- Mərhələləri nömrələnmiş log ilə yaz: `log.info("2/6 Normallaşdırma...")` — xəta hansı mərhələdə olduğu dərhal görünür.
- Kənar API çağırışlarını `try/except` ilə sar, `log.exception` ilə yaz, prosesi tam çökdürmə.
- Çıxış kodu qaytar (`sys.exit(main())`) — systemd/cron bunu oxuyur.
- Açarlar boşdursa əvvəlcədən dayan və nəyin çatmadığını de.

## Təhlükəsizlik

- `.env`, `token.json`, `service_account.json` **heç vaxt** commit edilmir — layihə yaradılanda `.gitignore`-u ilk fayl kimi yaz.
- Log-a token, tam URL-də açar, müştəri şəxsi məlumatı yazma.
- `.env.example`-də yalnız açar adları və nümunə format olsun.

## Bitirmədən əvvəl

1. `python selftest.py` — offline test keçir.
2. `python main.py --dry-run` — real axın, göndərmə yox.
3. README-də işlətmə əmrləri Azərbaycan dilində yazılıb.
4. Sonradan VPS-ə çıxacaqsa: Windows-a bağlı yol/`.bat` qoyma — `vps-deploy` skilinin tələblərinə uyğun saxla.
