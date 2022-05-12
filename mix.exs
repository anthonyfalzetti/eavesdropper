defmodule Eavesdropper.MixProject do
  use Mix.Project

  def project do
    [
      app: :eavesdropper,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  defp description do
    """
    Library for forwarding logs to another application
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*"],
      maintainers: ["Anthony Falzetti"],
      licenses: ["MIT"],
      links: %{"GitHub" => ""}
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    []
  end
end
