class Texi2html < Formula
  desc "Convert TeXinfo files to HTML"
  homepage "http://www.nongnu.org/texi2html/"
  url "http://download.savannah.gnu.org/releases/texi2html/texi2html-1.82.tar.gz"
  sha256 "6c7c94a2d88ffe218a33e91118c2b039336cbe3f2f8b4e3a78e4fd1502072936"

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "2505d8132d26d63d6e78c6d00d521bd7f4389b9ce2e497f9fbcc9227f1712efc" => :el_capitan
    sha256 "8af085412d76b324f4abd5fc48b2e32c0cbd3f24844e3dcffe41395866fbb58a" => :yosemite
    sha256 "5c3f4c8aa21f944f7a45844bcdecfab5ca0840d2bf7968b553fc9974fca7c0bf" => :mavericks
  end

  keg_only :provided_pre_mountain_lion

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--mandir=#{man}", "--infodir=#{info}"
    system "make", "install"
  end

  test do
    system "#{bin}/texi2html", "--help"
  end
end
