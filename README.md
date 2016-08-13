# Anoikis

A wormhole mapping tool.

## Setup

Create an application at https://developers.eveonline.com with a connection type
of `CREST Access` and the scope of `characterLocationRead`.

### Local

Create a `.env` file with the client id and secret for CREST and Alliance ID
for access:

```
# .env
CLIENT_ID=asdfjaskjdfajksdf
SECRET_KEY=a912je0asdu1nf9as
ALLIANCE_ID=1271293
```

### Production

Run the PilotLocationsJob have it find pilots' locations every 15 seconds.

```bash
RAILS_ENV=production bundle exec rake pilot_locator
```
