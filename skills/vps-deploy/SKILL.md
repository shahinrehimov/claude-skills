---
name: vps-deploy
description: Lokal PC-də işləyən bot/avtomatizasiyanı VPS-ə köçürüb 24/7 işlədən hala gətirmək — systemd, pm2, Docker, .env təhlükəsizliyi, log və restart. Use when the user mentions VPS, serverə köçürmək, 24/7 işləmək, hosting, deploy, systemd service, pm2, Docker deploy, sunucu, or wants a bot to keep running after the PC is off.
---

# VPS-ə deploy

Məqsəd: lokal PC-dən asılılığı bitirmək. Bot müştəriyə satılırsa 24/7 işləməsi vacibdir.

## 1. Deploy-dan əvvəl yoxla

- **Sərt kodlanmış Windows yolları var?** `C:\\Users\\...`, `\\\\` ayırıcıları, `run.bat` — Linux-da işləməz. `pathlib.Path` və nisbi yollara keçir.
- **`.env`, `token.json`, `service_account.json`, `oauth_client.json`** — bunlar git-ə düşməməlidir. `.gitignore`-u yoxla.
- **OAuth axını serverdə brauzer açmağa çalışırmı?** Headless serverdə `InstalledAppFlow.run_local_server()` işləmir. Token-i lokalda al, `token.json`-u servere köçür, refresh token-in `offline` olduğuna əmin ol.
- **Python versiyası** — lokalda 3.10-dursa serverdə də 3.10+ qur.
- `requirements.txt` tam və dondurulmuş olsun: `pip freeze > requirements.txt`.

## 2. Server hazırlığı (Ubuntu)

```bash
sudo apt update && sudo apt install -y python3-venv python3-pip git
sudo adduser --system --group --home /opt/botlar botuser
cd /opt/botlar && sudo -u botuser git clone <repo> app && cd app
sudo -u botuser python3 -m venv .venv
sudo -u botuser .venv/bin/pip install -r requirements.txt
```

`.env`-i `scp` ilə köçür və icazələri kilidlə:

```bash
sudo chown botuser:botuser .env && sudo chmod 600 .env
```

Botu **root olaraq işlətmə** — ayrı istifadəçi yarat.

## 3. Daimi işlətmə — systemd (Python üçün üstün seçim)

`/etc/systemd/system/viral-radar.service`:

```ini
[Unit]
Description=Viral Radar bot
After=network-online.target

[Service]
Type=simple
User=botuser
WorkingDirectory=/opt/botlar/app
EnvironmentFile=/opt/botlar/app/.env
ExecStart=/opt/botlar/app/.venv/bin/python main.py --schedule
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now viral-radar
sudo systemctl status viral-radar
journalctl -u viral-radar -f          # canlı log
```

**Günlük işlər üçün alternativ:** davamlı proses saxlamaq yerinə systemd **timer** və ya cron ilə gündə bir dəfə `main.py` işlətmək daha sadə və daha az yaddaş yeyir:

```
0 8 * * * cd /opt/botlar/app && .venv/bin/python main.py >> /var/log/viral-radar.log 2>&1
```

Node.js layihələri üçün `pm2 start index.js --name bot && pm2 save && pm2 startup`.

## 4. Webhook lazımdırsa (IG DM, Telegram webhook, Meta)

Meta/Instagram webhook **HTTPS və doğrulanmış domen** tələb edir:

```bash
sudo apt install -y nginx certbot python3-certbot-nginx
sudo certbot --nginx -d bot.domenim.az
```

nginx-i lokal porta reverse proxy et (`proxy_pass http://127.0.0.1:8000;`). Firewall: yalnız 22, 80, 443 açıq olsun (`sudo ufw allow 22,80,443/tcp && sudo ufw enable`).

## 5. Deploy-dan sonra

- Serveri yenidən başladıb botun özbaşına qalxdığını təsdiqlə: `sudo reboot`, sonra `systemctl status`.
- Log rotasiyası qur (fayla yazırsansa `logrotate`), yoxsa disk dolur.
- Yedək: `.env` və token fayllarının təhlükəsiz kopyasını saxla — serveri itirsən, bunları bərpa etmək ən çətin hissədir.
- Müştəriyə satılırsa: hansı VPS, aylıq xərc, hansı açarların kimə aid olduğunu qeyd et.

## Qayda

Serverdə **destruktiv əmr işlətməzdən əvvəl** (`rm -rf`, `systemctl stop`, DB drop, force push) istifadəçidən təsdiq al və nəyi silmək istədiyini əvvəlcə göstər.
