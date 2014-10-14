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
    sha1 "3495cb05210a3d70ef8d39835502afc28af8c2a2" => :mavericks
    sha1 "430aaddeb6f59729e9216ba67223a8ce1c5b9ee2" => :mountain_lion
    sha1 "f1ff364ff4e0dc54483a370a8ea54abf150f4f22" => :lion
  end

  head "https://github.com/fontforge/fontforge.git"

  option "with-gif", "Build with GIF support"
  option "with-x", "Build with X11 support, building the app bundle"

  # Autotools are required to build from source in all releases.
  # I have upstreamed a request to change this, so keep monitoring the situation.
  # Libtool must be :libltdl or bottling errors occur.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on :libltdl
  depends_on "ossp-uuid"
  depends_on "gettext"
  depends_on "pango"
  depends_on "libpng"   => :recommended
  depends_on "jpeg"     => :recommended
  depends_on "libtiff"  => :recommended
  depends_on :x11 if build.with? "x"
  depends_on "giflib" if build.with? "gif"
  depends_on "libspiro" => :optional
  depends_on "fontconfig"
  # The below two below dependencies are highly unrecommended for now
  # https://github.com/fontforge/fontforge/issues/1837
  # They should be made recommended again when functional.
  depends_on "zeromq" => :optional
  depends_on "czmq" if build.with? "zeromq"
  depends_on "cairo"
  depends_on :python if MacOS.version <= :snow_leopard

  fails_with :llvm do
    build 2336
    cause "Compiling cvexportdlg.c fails with error: initializer element is not constant"
  end

  # Fix Fontforge collab tools causing folder to build inside bin
  # That folder causes audit build failures
  # https://github.com/fontforge/fontforge/pull/1838
  if build.with? "zeromq"
    patch do
      url "https://github.com/fontforge/fontforge/pull/1838.diff"
      sha1 "5e7a848fd035b5b2aa18e9398f755feeb0bfafbb"
    end
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

    # Fontforge is *really* bad at finding the ossp-uuid dependency. Help it.
    # It wildly ignores the uuid pkg-config file, so manually give it flags.
    ENV.prepend "LIBUUID_CFLAGS", "-I#{Formula["ossp-uuid"].include}"
    ENV.prepend "LIBUUID_LIBS", "-L#{Formula["ossp-uuid"].lib}"

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
