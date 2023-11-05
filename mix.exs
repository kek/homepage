defmodule Hello.Mixfile do
  use Mix.Project

  def project do
    [
      app: :hello,
      version: "0.0.7",
      elixir: "~> 1.15",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [] ++ Mix.compilers() ++ [],
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Hello.Supervisor, []},
      applications: [
        :phoenix,
        :phoenix_pubsub,
        :phoenix_html,
        :logger,
        :cowboy,
        :gettext
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_), do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.7"},
      {:phoenix_view, "~> 2.0"},
      {:phoenix_pubsub, "~> 2.1"},
      {:phoenix_html, "~> 3.3"},
      {:phoenix_live_reload, "~> 1.4"},
      {:gettext, "~> 0.23.1"},
      {:cowboy, "~> 2.10"},
      {:plug_cowboy, "~> 2.6"},
      {:jason, "~> 1.4"},
      {:mix_test_watch, "~> 1.1", only: :dev, runtime: false}
    ]
  end
end
