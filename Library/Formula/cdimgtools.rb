class Cdimgtools < Formula
  desc "Command-line tools to inspect and manipulate CD/DVD images"
  homepage "http://home.gna.org/cdimgtools/"
  url "http://download.gna.org/cdimgtools/cdimgtools-0.3.tar.gz"
  sha256 "023037e3dd3224076748bc1e5c9cb1bff9fd4348de58912bc62223f39558b1da"
  head "https://git.gitorious.org/cdimgtools/cdimgtools.git"

  depends_on "libdvdcss"
  depends_on "libdvdread"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install", "install-doc-man"
  end

  test do
    system "#{bin}/dvdimgdecss", "-V"
    system "#{bin}/cssdec", "-V"
  end
end
