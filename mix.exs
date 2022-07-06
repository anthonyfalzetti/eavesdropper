defmodule Eavesdropper.MixProject do
  use Mix.Project

  def project do
    [
      app: :eavesdropper,
      version: "0.0.2",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      source_url: "https://github.com/anthonyfalzetti/eavesdropper"
    ]
  end

  defp description do
    """
    An elixir log forwarding library
    """
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/anthonyfalzetti/eavesdropper"},
      maintainers: ["Anthony Falzetti"],
      name: "eavesdropper"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.14", only: :dev, runtime: false}
    ]
  end
end
