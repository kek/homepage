import Config

config :hello, namespace: Hello

config :hello, Hello.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "gJATC1LVk4KuW6zj2CfhBdkWei5/p/JYMilDOqYQMwrMZxQr4/Lgf8gLMHXZcgNp",
  render_errors: [view: Hello.ErrorView, accepts: ~w(html json)],
  pubsub_server: Hello.PubSub,
  server: true

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

import_config "#{Mix.env()}.exs"
