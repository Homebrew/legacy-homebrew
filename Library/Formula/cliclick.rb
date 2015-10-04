class Cliclick < Formula
  desc "Tool for automating emulated mouse clicks"
  homepage "https://www.bluem.net/jump/cliclick/"
  url "https://github.com/BlueM/cliclick/archive/3.1.tar.gz"
  sha256 "d54273403ea786facb56fa85e8025f8fbf6bd1819ecd4b24625fa110a4ca3bec"

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
