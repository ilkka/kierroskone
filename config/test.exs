import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :kierroskone, Kierroskone.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "kierroskone_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :kierroskone, KierroskoneWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "8tzn5kZdymzXOJNm8pLgLq2Z2wLJmcTqVGvaBgISlTF2cbPwn1NqA8QF0DKGNJc5",
  server: false,
  laptime_api_token: "laptime-test-token"

# In test we don't send emails.
config :kierroskone, Kierroskone.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
