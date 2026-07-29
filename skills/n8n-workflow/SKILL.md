---
name: n8n-workflow
description: n8n workflow JSON qurmaq, redaktə etmək və import üçün hazırlamaq — node strukturu, connections, credential, webhook, cron, error handling. Use when the user mentions n8n, workflow JSON, node bağlantısı, webhook node, cron node, automation flow import, or wants a Python/manual automation converted into an n8n workflow.
---

# n8n workflow qurmaq

## Fayl strukturu

n8n import edilə bilən workflow minimum bu formada olmalıdır:

```json
{
  "name": "Workflow adı",
  "nodes": [ ... ],
  "connections": { ... },
  "settings": { "executionOrder": "v1" }
}
```

Hər node:

```json
{
  "id": "unikal-uuid-vari-string",
  "name": "Node adı",
  "type": "n8n-nodes-base.httpRequest",
  "typeVersion": 4.2,
  "position": [x, y],
  "parameters": { ... }
}
```

`connections` node **adları** ilə qurulur (id ilə deyil) — bu ən çox səhv edilən yerdir:

```json
"connections": {
  "Node adı": {
    "main": [[{ "node": "Növbəti node", "type": "main", "index": 0 }]]
  }
}
```

## Qaydalar

- **Node adları unikal olmalıdır** — təkrar ad connections-u sındırır.
- **Position** vermə vərdişi et (`[x, y]`, addım ~220px sağa) — yoxsa import olunanda nodelar üst-üstə düşür.
- **Credential-ları JSON-a yazma.** Yalnız istinad qoy:
  ```json
  "credentials": { "telegramApi": { "id": "1", "name": "Telegram account" } }
  ```
  Faktiki token/açarları n8n UI-da Credentials bölməsində əlavə etmək lazımdır — istifadəçiyə bunu ayrıca de.
- **Trigger node mütləqdir**: `n8n-nodes-base.scheduleTrigger` (cron) və ya `n8n-nodes-base.webhook`.
- **Webhook** üçün `path` unikal olmalı, `httpMethod` düzgün seçilməli. Test URL ilə production URL fərqlidir — production yalnız workflow **active** olanda işləyir.
- **Kod lazım olanda** `n8n-nodes-base.code` (JS) istifadə et; `items` massivi qaytarmalıdır: `return items.map(i => ({ json: {...} }))`.
- **Xəta idarəsi**: uzunmüddətli axınlarda kritik node-lara `onError: "continueRegularOutput"` və ya ayrıca **Error Trigger** workflow qoy — yoxsa bir API xətası bütün günlük axını dayandırır.
- **Rate limit**: dövr içində HTTP çağırışları varsa `n8n-nodes-base.splitInBatches` + gecikmə istifadə et.

## Tez-tez işlənən node tipləri

| Məqsəd | type |
|---|---|
| Cron/planlayıcı | `n8n-nodes-base.scheduleTrigger` |
| Webhook | `n8n-nodes-base.webhook` |
| HTTP sorğu (API) | `n8n-nodes-base.httpRequest` |
| Google Sheets | `n8n-nodes-base.googleSheets` |
| Telegram | `n8n-nodes-base.telegram` |
| Şərt | `n8n-nodes-base.if` / `n8n-nodes-base.switch` |
| JS kod | `n8n-nodes-base.code` |
| Batch dövrü | `n8n-nodes-base.splitInBatches` |

Anthropic/Claude çağırışı üçün ən sadə yol `httpRequest` ilə `https://api.anthropic.com/v1/messages` — header-lər: `x-api-key`, `anthropic-version: 2023-06-01`, `content-type: application/json`.

## Yoxlama

JSON yazdıqdan sonra ən azı sintaksisi təsdiqlə:

```powershell
Get-Content workflow.json -Raw | ConvertFrom-Json | Out-Null; if ($?) { "JSON OK" }
```

Sonra istifadəçiyə de: n8n → **Workflows → Import from File** → credential-ları bağla → **Test workflow** → yalnız uğurlu testdən sonra **Active** et.

## Mövcud layihə

`C:\\Users\\bakht\\pixenzz-viral-radar\\n8n\\pixenzz-viral-radar.workflow.json` — bu evdə qurulmuş nümunədir. Yeni workflow qurarkən əvvəlcə ona bax, adlandırma və struktur üslubunu təkrarla.
