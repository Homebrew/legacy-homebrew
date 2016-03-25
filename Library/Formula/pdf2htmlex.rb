class Pdf2htmlex < Formula
  desc "PDF to HTML converter"
  homepage "https://coolwanglu.github.io/pdf2htmlEX/"
  url "https://github.com/coolwanglu/pdf2htmlEX/archive/v0.14.6.tar.gz"
  sha256 "320ac2e1c2ea4a2972970f52809d90073ee00a6c42ef6d9833fb48436222f0e5"
  revision 1

  head "https://github.com/coolwanglu/pdf2htmlEX.git"

  bottle do
    sha256 "7fb9a99daaea6f372d7ea2bc2511114bb719deb3b8a35f589a547211d053c22a" => :el_capitan
    sha256 "3e8730530fe8eae8ff63b8eb3539fd6e55f959d6edd10a5fbb2fdd605221c57e" => :yosemite
    sha256 "ed3f86c149d5ce601e6d63dcae147f541a0745623244a7bc0a88941ec5963b5f" => :mavericks
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

  # Pdf2htmlex use an outdated, customised Fontforge installation.
  # See https://github.com/coolwanglu/pdf2htmlEX/wiki/Building
  resource "fontforge" do
    url "https://github.com/coolwanglu/fontforge.git", :branch => "pdf2htmlEX"
  end

  # And failures
  fails_with :llvm do
    build 2336
    cause "Compiling cvexportdlg.c fails with error: initializer element is not constant"
  end

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
