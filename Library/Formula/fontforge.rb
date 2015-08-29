class Fontforge < Formula
  desc "Command-line outline and bitmap font editor/converter"
  homepage "https://fontforge.github.io"
  url "https://github.com/fontforge/fontforge/archive/20150824.tar.gz"
  sha256 "28ab2471cb010c1fa75b8ab8191a1dded81fe1e9490aa5ff6ab4706a4c78ff27"
  head "https://github.com/fontforge/fontforge.git"

  bottle do
    revision 1
    sha256 "f8228c12d9bcda768334b32b51251edd9c970e6a6f213896b7d74e8dfa96231d" => :yosemite
    sha256 "b303e97388537aa75f15e4f9f16d84470b4f6fa9aaa2b2cb151a6b288903886c" => :mavericks
    sha256 "065e2c82a000ed3d07f6ac8edc41b530b99f81b10c42442b3887daa5007223cb" => :mountain_lion
  end

  option "with-giflib", "Build with GIF support"
  option "with-extra-tools", "Build with additional font tools"

  deprecated_option "with-gif" => "with-giflib"

  # Autotools are required to build from source in all releases.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool" => :run
  depends_on "gettext"
  depends_on "pango"
  depends_on "zeromq"
  depends_on "czmq"
  depends_on "cairo"
  depends_on "libpng" => :recommended
  depends_on "jpeg" => :recommended
  depends_on "libtiff" => :recommended
  depends_on "giflib" => :optional
  depends_on "libspiro" => :optional
  depends_on :python if MacOS.version <= :snow_leopard

  # This may be causing font-display glitches and needs further isolation & fixing.
  # https://github.com/fontforge/fontforge/issues/2083
  # https://github.com/Homebrew/homebrew/issues/37803
  depends_on "fontconfig"

  resource "gnulib" do
    url "git://git.savannah.gnu.org/gnulib.git",
        :revision => "9a417cf7d48fa231c937c53626da6c45d09e6b3e"
  end

  fails_with :llvm do
    build 2336
    cause "Compiling cvexportdlg.c fails with error: initializer element is not constant"
  end

  def install
    # Don't link libraries to libpython, but do link binaries that expect
    # to embed a python interpreter
    # https://github.com/fontforge/fontforge/issues/2353#issuecomment-121009759
    ENV["PYTHON_CFLAGS"] = `python-config --cflags`.chomp
    ENV["PYTHON_LIBS"] = "-undefined dynamic_lookup"
    python_libs = `python2.7-config --ldflags`.chomp
    inreplace "fontforgeexe/Makefile.am" do |s|
      oldflags = s.get_make_var "libfontforgeexe_la_LDFLAGS"
      s.change_make_var! "libfontforgeexe_la_LDFLAGS", "#{python_libs} #{oldflags}"
    end

    # Disable Homebrew detection
    # https://github.com/fontforge/fontforge/issues/2425
    inreplace "configure.ac", 'test "y$HOMEBREW_BREW_FILE" != "y"', "false"

    args = %W[
      --prefix=#{prefix}
      --disable-silent-rules
      --disable-dependency-tracking
      --with-pythonbinary=#{which "python2.7"}
      --without-x
    ]

    args << "--without-libpng" if build.without? "libpng"
    args << "--without-libjpeg" if build.without? "jpeg"
    args << "--without-libtiff" if build.without? "libtiff"
    args << "--without-giflib" if build.without? "giflib"
    args << "--without-libspiro" if build.without? "libspiro"

    # Fix linker error; see: https://trac.macports.org/ticket/25012
    ENV.append "LDFLAGS", "-lintl"

    # Reset ARCHFLAGS to match how we build
    ENV["ARCHFLAGS"] = "-arch #{MacOS.preferred_arch}"

    # Bootstrap in every build: https://github.com/fontforge/fontforge/issues/1806
    resource("gnulib").fetch
    system "./bootstrap",
           "--gnulib-srcdir=#{resource("gnulib").cached_download}",
           "--skip-git"
    system "./configure", *args
    system "make"
    system "make", "install"

    # The app here is not functional. You should install Fontforge
    # via the Cask if you want GUI/App support.
    (share/"fontforge/osx/FontForge.app").rmtree

    if build.with? "extra-tools"
      cd "contrib/fonttools" do
        system "make"
        bin.install Dir["*"].select { |f| File.executable? f }
      end
    end
  end

  test do
    system bin/"fontforge", "-version"
    system "python", "-c", "import fontforge"
  end
end
