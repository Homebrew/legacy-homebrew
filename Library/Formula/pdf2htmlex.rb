require "formula"

class Pdf2htmlex < Formula
  homepage "https://coolwanglu.github.io/pdf2htmlEX/"
  url "https://github.com/coolwanglu/pdf2htmlEX/archive/v0.12.tar.gz"
  sha256 "7868ff5cd69758d094fd6076e4d0888e5033bf8799a5355bf4470e91967147a8"

  head "https://github.com/coolwanglu/pdf2htmlEX.git"

  bottle do
    sha1 "180d74f4c3c43d2809b43c3e111129ceced47d53" => :mavericks
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
  depends_on "libtool" => :build
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

  def install
    resource("fontforge").stage do
      args = ["--prefix=#{prefix}/fontforge",
              "--without-libzmq",
              "--without-x",
              "--without-iconv",
              "--disable-python-scripting",
              "--disable-python-extension",
      ]

      # Fix linker error; see: http://trac.macports.org/ticket/25012
      ENV.append "LDFLAGS", "-lintl"

      # And fix the zlib hunting.
      ENV.append "ZLIB_CFLAGS", "-I/usr/include"
      ENV.append "ZLIB_LIBS", "-L/usr/lib -lz"

      # Reset ARCHFLAGS to match how we build
      ENV["ARCHFLAGS"] = "-arch #{MacOS.preferred_arch}"

      system "./autogen.sh"
      system "./configure", *args

      # Fix hard-coded install locations that don't respect the target bindir
      inreplace "Makefile", "/Applications", "$(prefix)"

      system "make"
      system "make", "install"

      # Fix breaking zlib pkg-config file issue.
      inreplace "#{prefix}/fontforge/lib/pkgconfig/libfontforge.pc", "zlib", " "

      # Fix breaking zlib pkg-config file issue number 2.
      inreplace "#{prefix}/fontforge/lib/pkgconfig/libfontforgeexe.pc", "zlib", " "
    end

    # Prepend the paths to always find this dep fontforge instead of another.
    ENV.prepend_path "PKG_CONFIG_PATH", "#{prefix}/fontforge/lib/pkgconfig"
    ENV.prepend_path "PATH", "#{prefix}/fontforge/bin"
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    curl "-O", "http://partners.adobe.com/public/developer/en/xml/AdobeXMLFormsSamples.pdf"
    system "#{bin}/pdf2htmlEX", "AdobeXMLFormsSamples.pdf"
  end
end
