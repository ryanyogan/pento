use Mix.Config

config :pento,
  ecto_repos: [Pento.Repo]

config :pento, PentoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ip2gMC36AixBoOnVSRe0emFsUTmDfJdg5Bm0i/ejVDw397lqDyTPDvGklg1zxdGm",
  render_errors: [view: PentoWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Pento.PubSub,
  live_view: [signing_salt: "yHJlah1N"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"
