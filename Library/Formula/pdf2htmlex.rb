class Pdf2htmlex < Formula
  desc "PDF to HTML converter"
  homepage "https://coolwanglu.github.io/pdf2htmlEX/"
  url "https://github.com/coolwanglu/pdf2htmlEX/archive/v0.13.6.tar.gz"
  sha256 "fc133a5791bfd76a4425af16c6a6a2460f672501b490cbda558213cb2b03d5d7"
  revision 7

  head "https://github.com/coolwanglu/pdf2htmlEX.git"

  bottle do
    sha256 "6968357c3c4c095c2f54087059ba556879492dfc146712f5ca9604cf17fea9f6" => :el_capitan
    sha256 "c4b05eb6a8e544e044588fa113881f9757dcc907f15df7d9fe5bb69c1e43f8e3" => :yosemite
    sha256 "e1d58c45767348887a1d24e276bad32516b9dca3db365fde2ba1756836e252fd" => :mavericks
  end

  # Pdf2htmlex use an outdated, customised Fontforge installation.
  # See https://github.com/coolwanglu/pdf2htmlEX/wiki/Building
  resource "fontforge" do
    url "https://github.com/coolwanglu/fontforge.git", :branch => "pdf2htmlEX"
  end

  depends_on :macos => :lion
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "poppler"
  depends_on "gnu-getopt"
  depends_on "ttfautohint" => :recommended if MacOS.version > :snow_leopard

  # Fontforge dependencies
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :run
  depends_on "glib"
  depends_on "pango"
  depends_on "gettext"
  depends_on "libpng"   => :recommended
  depends_on "jpeg"     => :recommended
  depends_on "libtiff"  => :recommended

  # And failures
  fails_with :llvm do
    build 2336
    cause "Compiling cvexportdlg.c fails with error: initializer element is not constant"
  end

  # Fix a compilation failure with poppler 0.31.0+
  # Upstream is aware of the issue and suggested this patch:
  # https://github.com/coolwanglu/pdf2htmlEX/commit/d4fc82b#commitcomment-12239022
  patch :DATA

  def install
    resource("fontforge").stage do
      args = %W[
        --prefix=#{prefix}/fontforge
        --without-libzmq
        --without-x
        --without-iconv
        --disable-python-scripting
        --disable-python-extension
      ]

      # Fix linker error; see: https://trac.macports.org/ticket/25012
      ENV.append "LDFLAGS", "-lintl"

      # Reset ARCHFLAGS to match how we build
      ENV["ARCHFLAGS"] = "-arch #{MacOS.preferred_arch}"

      system "./autogen.sh"
      system "./configure", *args

      system "make"
      system "make", "install"
    end

    # Prepend the paths to always find this dep fontforge instead of another.
    ENV.prepend_path "PKG_CONFIG_PATH", "#{prefix}/fontforge/lib/pkgconfig"
    ENV.prepend_path "PATH", "#{prefix}/fontforge/bin"
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/pdf2htmlEX", test_fixtures("test.pdf")
  end
end

__END__
diff --git a/3rdparty/poppler/git/CairoFontEngine.cc b/3rdparty/poppler/git/CairoFontEngine.cc
index 229a86c..7cc448b 100644
--- a/3rdparty/poppler/git/CairoFontEngine.cc
+++ b/3rdparty/poppler/git/CairoFontEngine.cc
@@ -421,7 +421,7 @@ CairoFreeTypeFont *CairoFreeTypeFont::create(GfxFont *gfxFont, XRef *xref,
   ref = *gfxFont->getID();
   fontType = gfxFont->getType();

-  if (!(fontLoc = gfxFont->locateFont(xref, gFalse))) {
+  if (!(fontLoc = gfxFont->locateFont(xref, nullptr))) {
     error(errSyntaxError, -1, "Couldn't find a font for '{0:s}'",
	gfxFont->getName() ? gfxFont->getName()->getCString()
	                       : "(unnamed)");
