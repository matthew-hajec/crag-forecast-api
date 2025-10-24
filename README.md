# CragFinder

This the Crag Finder API. 

It uses the bandit web sever, which is a production ready Elixir web server.

In production, it exposes ONE route:

## Routes

**There are some debug routes exposed in developmnet mode. Look at `/lib/crag_forecast/http/router.ex`. This document only describes the production endpoint(s).**

### Nearby Crags

Get a list of crags, alongside their weather information, within `radius_km` of the coordinate pair (`latitude`, `longitude`).

#### URL:
- `/forecast/{latitude}/{longitude}/{radius_km}`

#### Paramters:
- `latitude` is a float between -90 and 90.
- `longitude` is a float between -180 and 180.
- `radius_km` is an integer between 0 and 1000.

#### Responses:
##### Success:
- Staus Code: `200`
- Content Type: `application/json`
- Content: See `/lib/crag_forecast/forecast_provider`

##### Invalid Paramters:
- Status Code: `400`
- Content Type: `application/json`
- Content: `{"message": "Invalid Parameters"}` (or something like that)

## Environment Configuration

This application allows for configuration via environment variables:

These defaults are for when `MIX_ENV=prod`. See `config/config.exs`.

- `PORT` (integer): Port for the server to listen on.
  - Default: `4000`
- `CRAG_CSV_URL` (string): URL for a list of routes.
  - Default: `https://docs.google.com/spreadsheets/d/e/2PACX-1vQX23tF6CLyQHv8FtCQ54MdGeTtQb-gMNgMpOE-lCiZS4uP9D-6OaswesxP4M2oZrZuJrW7PMThYEJb/pub?output=csv`
- `CORS_ALLOWED_ORIGINs` (string): Value for the `Access-Control-Allow-Origin` header.
  - Default: `*`