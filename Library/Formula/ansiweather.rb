class Ansiweather < Formula
  desc "Weather in your terminal, with ANSI colors and Unicode symbols"
  homepage "https://github.com/fcambus/ansiweather"
  url "https://github.com/fcambus/ansiweather/archive/1.04.tar.gz"
  sha256 "a85b0aba801f1fa3d386e92017c9b6af242b0243961a2a2f2e44096a8d7ddd75"

  head "https://github.com/fcambus/ansiweather.git"

  depends_on "jq"

  def install
    bin.install "ansiweather"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    output = shell_output("#{bin}/ansiweather -l Ithaca,NY -s false -a false")
    output.force_encoding("UTF-8") if output.respond_to?(:force_encoding)
    assert_match /Current weather in Ithaca/, output
  end
end
