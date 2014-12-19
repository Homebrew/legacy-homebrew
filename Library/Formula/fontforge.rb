require "formula"

class Fontforge < Formula
  homepage "https://fontforge.github.io"
  url "https://github.com/fontforge/fontforge/releases/download/20141126/fontforge-2014-11-26-Unix-Source.tar.gz"
  sha1 "ecd776480a47cdcbe1b30ce275172d7d52288e77"
  head "https://github.com/fontforge/fontforge.git"
  version "20141126"

  bottle do
    sha1 "9cb3881adf612eae21aa4c70eb17907a96f05d8d" => :yosemite
    sha1 "a079566b826ae865e2f393eaaa56cdc097d1f458" => :mavericks
    sha1 "dcb8c5630310b8a7c534e90e4579d2734a0154ab" => :mountain_lion
  end

  deprecated_option "with-x" => "with-x11"
  deprecated_option "with-gif" => "with-giflib"

  option "with-giflib", "Build with GIF support"

  # Autotools are required to build from source in all releases.
  # I have upstreamed a request to change this, so keep monitoring the situation.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool" => :run
  depends_on "gettext"
  depends_on "pango"
  depends_on "zeromq"
  depends_on "czmq"
  depends_on "libpng"   => :recommended
  depends_on "jpeg"     => :recommended
  depends_on "libtiff"  => :recommended
  depends_on :x11 => :optional
  depends_on "gtk+" => :optional
  depends_on "giflib" => :optional
  depends_on "libspiro" => :optional
  depends_on "fontconfig"
  depends_on "cairo"
  depends_on :python if MacOS.version <= :snow_leopard

  fails_with :llvm do
    build 2336
    cause "Compiling cvexportdlg.c fails with error: initializer element is not constant"
  end

  def install
    args = ["--prefix=#{prefix}"]

    args << "--with-x" if build.with? "x11"
    args << "--enable-gtk2-use" if build.with? "gtk+"

    args << "--without-libpng" if build.without? "libpng"
    args << "--without-libjpeg" if build.without? "jpeg"
    args << "--without-libtiff" if build.without? "libtiff"
    args << "--without-giflib" if build.without? "giflib"
    args << "--without-libspiro" if build.without? "libspiro"

    # Fix linker error; see: http://trac.macports.org/ticket/25012
    ENV.append "LDFLAGS", "-lintl"

    # Add environment variables for system libs
    ENV.append "ZLIB_CFLAGS", "-I/usr/include"
    ENV.append "ZLIB_LIBS", "-L/usr/lib -lz"

    # And finding Homebrew's Python
    ENV.append_path "PKG_CONFIG_PATH", "#{HOMEBREW_PREFIX}/Frameworks/Python.framework/Versions/2.7/lib/pkgconfig/"
    ENV.prepend "LDFLAGS", "-L#{%x(python-config --prefix).chomp}/lib"

    # Reset ARCHFLAGS to match how we build
    ENV["ARCHFLAGS"] = "-arch #{MacOS.preferred_arch}"

    # Bootstrap in every build. See the link below.
    system "./bootstrap" #https://github.com/fontforge/fontforge/issues/1806
    system "./configure", *args
    system "make"
    system "make", "install"

    # Link this to enable symlinking into /Applications with brew linkapps.
    # The name is case-sensitive. It breaks without both F's capitalised.
    ln_s "#{share}/fontforge/osx/FontForge.app", prefix
  end

  test do
    system "#{bin}/fontforge", "-version"
  end
end
