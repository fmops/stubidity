defmodule Stubidity.MixProject do
  use Mix.Project

  def project do
    [
      app: :stubidity,
      version: "0.3.1",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      description:
        "A plug that stubs popular foundation model APIs for development and testing purposes.",
      aliases: aliases(),
      deps: deps(),
      package: package(),
      name: "stubidity",
      source_url: "https://github.com/fmops/stubidity"
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Stubidity.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:plug, "~> 1.16"},
      {:jason, "~> 1.4"},
      {:phoenix, "~> 1.7.14"},
      {:phoenix_live_dashboard, "~> 0.8.3"},
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.20"},
      {:dns_cluster, "~> 0.1.1"},
      {:bandit, "~> 1.5"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get"]
    ]
  end


  defp package() do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["@feynmanliang"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/fmops/stubidity"}
    ]
  end
end
