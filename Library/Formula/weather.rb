require "formula"

class Weather < Formula
  homepage "https://github.com/jfrazelle/weather"
  url "https://github.com/jfrazelle/weather/archive/eefdf7d75ff81944d0a39d696f623955ca84076b.tar.gz"
  sha1 "43ffc2515f8298e79b0c2c01c602085b1b3ccffb"
  head "https://github.com/jfrazelle/weather.git"
  version "0.1.0"

  depends_on "go" => :build
  depends_on :hg => :build

  def install
    ENV["GOPATH"] = buildpath

    system "go", "get", "github.com/mitchellh/colorstring"

    # Build and install weather
    system "go", "build", "-o", "weather"
    bin.install "weather"
  end

  test do
    system "#{bin}/weather", "-v"
  end
end
