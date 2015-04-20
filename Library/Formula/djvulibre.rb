class Djvulibre < Formula
  homepage "http://djvu.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/djvu/DjVuLibre/3.5.27/djvulibre-3.5.27.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/d/djvulibre/djvulibre_3.5.27.orig.tar.gz"
  sha256 "e69668252565603875fb88500cde02bf93d12d48a3884e472696c896e81f505f"

  head do
    url "git://git.code.sf.net/p/djvu/djvulibre-git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  bottle do
    revision 1
    sha1 "306baf176acba6f71f3381a010fa78ff80e62ba6" => :yosemite
    sha1 "61a53093e18457fb4235cc0afe3717eef851b85e" => :mavericks
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
