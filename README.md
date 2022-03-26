# Kierroskone

To start your Phoenix server:

* Install dependencies with `mix deps.get`
* Create and migrate your database with `mix ecto.setup`
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Running migrations in prod

Attach to the running container and run

```shell
./kierroskone/bin/kierroskone eval "Kierroskone.Release.migrate"
```

## Testing the laptime API endpoint

For Dirt 2.0 (in PowerShell) do

```shell
Import-Csv -Delimiter ';' laptimes.csv | ConvertTo-Json -AsArray | Invoke-RestMethod -Method Post -ContentType application/json -Headers @{"x-api-token" = "laptime-dev-token"} http://localhost:4000/api/laptime-import/dirt2
```
