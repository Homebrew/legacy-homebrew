class Texi2html < Formula
  desc "Convert TeXinfo files to HTML"
  homepage "http://www.nongnu.org/texi2html/"
  url "http://download.savannah.gnu.org/releases/texi2html/texi2html-1.82.tar.gz"
  sha256 "6c7c94a2d88ffe218a33e91118c2b039336cbe3f2f8b4e3a78e4fd1502072936"

  bottle do
    revision 1
    sha1 "8a7d68b823f65d99cc3946b54f5cb58daeda2674" => :yosemite
    sha1 "0131f620ee0369d1bfb0beb9cf98ff42b43bee61" => :mavericks
    sha1 "2eefa2d9e010b7e6e9d67e2e847fa6d5ae9c9983" => :mountain_lion
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
