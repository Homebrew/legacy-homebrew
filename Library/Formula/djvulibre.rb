class Djvulibre < Formula
  desc "DjVu viewer"
  homepage "http://djvu.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/djvu/DjVuLibre/3.5.27/djvulibre-3.5.27.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/d/djvulibre/djvulibre_3.5.27.orig.tar.gz"
  sha256 "e69668252565603875fb88500cde02bf93d12d48a3884e472696c896e81f505f"

  bottle do
    revision 1
    sha256 "eac32524be9ba27942b248fb6b330dcbb1e905b5e50a3957b9b0ed389e10f797" => :el_capitan
    sha256 "8b23e45b77fd05646e3b81012eccdae2ecc67fe668b6974acf2ff744b1585402" => :yosemite
    sha256 "b62d17ef5e5adf9da600eff7aa68b60f9eb7e7c067c6143749e0f74664c2618a" => :mavericks
  end

  head do
    url "git://git.code.sf.net/p/djvu/djvulibre-git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "jpeg"
  depends_on "libtiff"

  def install
    system "./autogen.sh" if build.head?
    # Don't build X11 GUI apps, Spotlight Importer or QuickLook plugin
    system "./configure", "--prefix=#{prefix}", "--disable-desktopfiles"
    system "make"
    system "make", "install"
    (share/"doc/djvu").install Dir["doc/*"]
  end

  test do
    output = shell_output("#{bin}/djvused -e n #{share}/doc/djvu/lizard2002.djvu")
    assert_equal "2", output.strip
  end
end
