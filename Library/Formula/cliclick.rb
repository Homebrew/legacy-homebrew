require "formula"

class Cliclick < Formula
  desc "Tool for automating emulated mouse clicks"
  homepage "http://www.bluem.net/jump/cliclick/"
  url "https://github.com/BlueM/cliclick/archive/3.1.tar.gz"
  sha256 "d54273403ea786facb56fa85e8025f8fbf6bd1819ecd4b24625fa110a4ca3bec"

  bottle do
    cellar :any
    sha1 "a99a5a82eb63ef3519935c567daeef9427af2938" => :yosemite
    sha1 "f33e632b31478da84d02723c23da2fbed5a6fe70" => :mavericks
    sha1 "4bbce551db8989d4d27a833bb29c8f888aa221ba" => :mountain_lion
  end

  def install
    system "make"
    bin.install "cliclick"
  end

  test do
    system bin/"cliclick", "p:OK"
  end
end
