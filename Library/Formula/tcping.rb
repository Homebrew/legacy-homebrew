class Tcping < Formula
  desc "TCP connect to the given IP/port combo"
  homepage "http://www.linuxco.de/tcping/tcping.html"
  url "http://www.linuxco.de/tcping/tcping-1.3.5.tar.gz"
  sha256 "1ad52e904094d12b225ac4a0bc75297555e931c11a1501445faa548ff5ecdbd0"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "2fb4f218abf6de64e4a8ee49447567aa0666f212dfb49f45a4f8d8f30ef40076" => :el_capitan
    sha256 "a9e7c0063e20ea023d0b5ad29564e2f8744e5685f3f3b794f02d5ceb4c316421" => :yosemite
    sha256 "92f3a1c1ed85cbfec37ed40f4f8234262b28758072d69765995839cbf290f393" => :mavericks
  end

  def install
    system "make"
    bin.install "tcping"
  end

  test do
    system "#{bin}/tcping", "www.google.com", "80"
  end
end
