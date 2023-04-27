defmodule Stubidity.MixProject do
  use Mix.Project

  def project do
    [
      app: :stubidity,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      description: "A plug that stubs popular foundation model APIs for development and testing purposes.",
      package: package(),
      deps: deps(),
      name: "stubidity",
      source_url: "https://github.com/fmops/stubidity"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:plug, "~> 1.14"},
      {:jason, "~> 1.4"}
    ]
  end

  defp package() do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["@joshnuss"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/fmops/stubidity"}
    ]
  end
end
