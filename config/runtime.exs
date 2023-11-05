import Config

config :hello, gurka: System.get_env("GURKA")

case System.get_env("SECRET_KEY_BASE") do
  nil -> nil
  something -> config :hello, Hello.Endpoint, secret_key_base: something
end
