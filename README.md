# claude-skills

Şəxsi **Claude Code skill** kolleksiyam — avtomatizasiya, kontent, dizayn və produksiya işləri üçün.
Skil = söhbətdə uyğun mövzu açılanda **özü yüklənən təlimat faylı**. Çağırmaq lazım deyil.

## Quraşdırma

Bütün skilləri qlobal olaraq quraşdır (hər layihədə işləyəcək):

**Windows / PowerShell**

```powershell
git clone https://github.com/shahinrehimov/claude-skills.git "$env:USERPROFILE\\claude-skills"
cd "$env:USERPROFILE\\claude-skills"
.\\install.ps1
```

**Linux / macOS**

```bash
git clone https://github.com/shahinrehimov/claude-skills.git ~/claude-skills
cd ~/claude-skills && bash install.sh
```

Skriptlər `skills/` altındakı hər qovluğu `~/.claude/skills/` içinə köçürür. Sonra Claude Code-u yenidən başlat — `/context` ilə yükləndiyini yoxlaya bilərsən.

Tək bir skil lazımdırsa qovluğu əl ilə köçür:

```powershell
Copy-Item -Recurse "skills\\carfy" "$env:USERPROFILE\\.claude\\skills\\"
```

## Skillər

### Avtomatizasiya və kod

| Skill | Nə üçün |
|---|---|
| `carfy` | Carfy Servis — Telegram AI qeyd botu + Instagram DM lid sistemi: müştəri qoşmaq, debug, alət əlavə etmək, deploy |
| `viral-radar` | Pixenzz Viral Radar — günlük viral kontent axını, işlətmə və mərhələ-mərhələ debug |
| `n8n-workflow` | n8n workflow JSON qurmaq: node strukturu, connections, credential, webhook, cron |
| `vps-deploy` | Botu VPS-ə köçürüb 24/7 işlətmək: systemd, cron, nginx/Caddy + HTTPS, log |
| `py-bot-scaffold` | Yeni Python avtomatizasiya layihəsi üçün standart skelet |

### Kontent və müştəri

| Skill | Nə üçün |
|---|---|
| `insta-content` | Reels/post mətni: hook, ssenari, caption, hashtag (Azərbaycan dilində) |
| `ffmpeg-video` | Video kəsmə, 9:16 çevirmə, sıxma, altyazı, birləşdirmə |
| `client-report` | Müştəri hesabatı, təklif və təhvil sənədi |

### Dizayn

| Skill | Nə üçün |
|---|---|
| `print-design` | Çap və açıqhava: ölçü/bleed, CMYK, DPI, çapa hazır fayl |
| `brand-identity` | Brend kimliyi: loqo dəsti, rəng sistemi, tipoqrafiya, brandbook |
| `social-visual` | Sosial media qrafikası: ölçülər, safe zone, karusel, thumbnail |
| `canva-design` | Canva MCP iş axını: brand kit, şablondan seriya, eksport |
| `ui-design` | Məhsul UI strukturu: spacing şkalası, form, cədvəl, dashboard, boş/xəta halları |
| `figma-mcp` | Figma MCP: dizayndan koda, koddan Figma-ya, design tokens |
| `frontend-design` | Veb UI-nin estetik istiqaməti (kənar mənbə — `creative-design/frontend-design`) |

### Produksiya

| Skill | Nə üçün |
|---|---|
| `archviz-render` | 3ds Max + V-Ray/Corona: kamera, işıq, render ayarları, animasiya |
| `motion-graphics` | After Effects / DaVinci: kompozisiya, easing, ekspressiya, render |

## Yeniləmə

Skildə dəyişiklik edəndə (lokal `~/.claude/skills/` içində) dəyişikliyi repoya qaytarmaq üçün:

```powershell
.\\publish.ps1 -Push
```

Bu skript lokal skilləri repoya köçürür, `carfy` skilindən server məlumatını təmizləyir və commit-dən əvvəl gizli məlumat axtarışı edir.

## Qeyd

Skillərdəki yollar bu quraşdırmaya xasdır (`C:\\Users\\bakht\\...`). Başqa mühitdə istifadə edəcəksənsə `SKILL.md` içindəki yolları uyğunlaşdır.

Repoda **heç bir açar, token və ya müştəri konfiqi yoxdur** — yalnız təlimat faylları.
