class Cliclick < Formula
  desc "Tool for emulating mouse and keyboard events"
  homepage "https://www.bluem.net/jump/cliclick/"
  url "https://github.com/BlueM/cliclick/archive/3.2.tar.gz"
  sha256 "11245e06030a1603200d56ef5cbb3b0ee182ca6fe11f1d88504b137d7ecc0d8a"

  bottle do
    cellar :any
    sha256 "24c75829c99056028aac3e670b3e1016ab0869d3ece946cac280a3b411150822" => :yosemite
    sha256 "c5058eab6b2c150fb5eba3f97833d076533f521ede2aae94f6acda0c7c49b19a" => :mavericks
    sha256 "352570d39895176322f7ca977189ad74adc7a5fa9310c238e66d4ca677e0153c" => :mountain_lion
  end

  def install
    system "make"
    bin.install "cliclick"
  end

  test do
    system bin/"cliclick", "p:OK"
  end
end
