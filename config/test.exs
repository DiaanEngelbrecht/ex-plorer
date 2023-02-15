import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :explorer, ExplorerWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "cRS/rtXdR5lyl9O+kWaxlIeyw6HqYdKC1m7am178h7kRKq+IHTgnW5LFjOSkZ69g",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
