require "formula"

class Fontforge < Formula
  homepage "https://fontforge.github.io"

  stable do
    url "https://github.com/fontforge/fontforge/releases/download/20141014/fontforge-20141014.tar.gz"
    sha1 "b366293e423a94d213824368460fa80f9a1ad810"

    # Upstream commit allowing non-/Applications app bundle to run.
    # Doesn't actually work for me yet in stable - Keep an eye on that.
    patch do
      url "https://github.com/fontforge/fontforge/commit/bce235d23b8.diff"
      sha1 "8ec20f07bbf5f93c052bed7304c6e667046910ef"
    end
  end

  bottle do
    revision 1
    sha1 "ef8e64045c5f97d154a8deb96efb94f72b4ecf6a" => :yosemite
    sha1 "37363b5e3923118b1b7eaeb7c4320b955fa7c8b5" => :mavericks
    sha1 "1d463715d0ca9d27dcac36904c28b750698f2de0" => :mountain_lion
  end

  head do
    url "https://github.com/fontforge/fontforge.git"

    # Remove this block after next stable release and make mandatory for all again.
    # Several unique issues fixed in HEAD.
    depends_on "zeromq"
    depends_on "czmq"
  end

  option "with-gif", "Build with GIF support"
  option "with-x", "Build with X11 support, building the app bundle"

  # Autotools are required to build from source in all releases.
  # I have upstreamed a request to change this, so keep monitoring the situation.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool" => :run
  depends_on "gettext"
  depends_on "pango"
  depends_on "libpng"   => :recommended
  depends_on "jpeg"     => :recommended
  depends_on "libtiff"  => :recommended
  depends_on :x11 if build.with? "x"
  depends_on "giflib" if build.with? "gif"
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

    args << "--with-x" if build.with? "x"

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
    ln_s "#{share}/fontforge/osx/Fontforge.app", "#{prefix}"
  end

  test do
    system "#{bin}/fontforge", "-version"
  end
end
