defmodule FirebaseAdmin.MixProject do
  use Mix.Project

  def project do
    [
      app: :firebase_admin,
      version: "0.2.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "FirebaseAdmin",
      package: package(),
      description: description(),
      source_url: "https://github.com/col/ex_firebase_admin",
      homepage_url: "https://github.com/col/ex_firebase_admin"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description() do
    "An elixir library to access Firebase admin features such as fetching user info and generating id tokens."
  end

  defp deps do
    [
      {:tesla, "~> 1.4"},
      {:goth, "~> 1.3"},
      {:hackney, "~> 1.17"},
      {:joken, "~> 2.0"},
      {:poison, "~> 4.0"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp package() do
    [
      name: "ex_firebase_admin",
      files: ~w(lib .formatter.exs mix.exs README.md LICENSE),
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/col/ex_firebase_admin"}
    ]
  end
end
