require "formula"

class Cliclick < Formula
  homepage "http://www.bluem.net/jump/cliclick/"
  url "https://github.com/BlueM/cliclick/archive/3.0.3.tar.gz"
  sha1 "7d2f21065c1d77f46292f72f7aa50c91abb48a53"

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
