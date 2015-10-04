class Djvulibre < Formula
  desc "DjVu viewer"
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
    sha256 "e68742330649c92707eef3711cc966e6f9de984572f13f5acd8694574dcdcfb4" => :el_capitan
    sha256 "6bcc53ce6acccef4ab6bdf3150887a054165fe7d6984917bf1a65af5ba9ab228" => :yosemite
    sha256 "ed02ea82754109ea5d3e6767d80d49133a6552696aa5405b30a93569886f6ce4" => :mavericks
    sha256 "a1fc4dd16370cb5949ce1df38105dbc94b7934f876b7e35c6e904927563d7f93" => :mountain_lion
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
