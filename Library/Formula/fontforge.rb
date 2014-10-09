require "formula"

class Fontforge < Formula
  homepage "https://fontforge.github.io"

  stable do
    url "https://github.com/fontforge/fontforge/archive/2.0.20140101.tar.gz"
    sha1 "abce297e53e8b6ff6f08871e53d1eb0be5ab82e7"

    depends_on "cairo" => :optional
    depends_on :python => :optional
  end

  bottle do
    sha1 "3495cb05210a3d70ef8d39835502afc28af8c2a2" => :mavericks
    sha1 "430aaddeb6f59729e9216ba67223a8ce1c5b9ee2" => :mountain_lion
    sha1 "f1ff364ff4e0dc54483a370a8ea54abf150f4f22" => :lion
  end

  head do
    url "https://github.com/fontforge/fontforge.git"

    depends_on "zeromq"
    depends_on "czmq"
    depends_on "cairo"
    depends_on :python if MacOS.version <= :snow_leopard
  end

  option 'with-gif', 'Build with GIF support'
  option 'with-x', 'Build with X11 support, building the app bundle'
  option 'with-python', 'Build with Python extensions and scripting'

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

  fails_with :llvm do
    build 2336
    cause "Compiling cvexportdlg.c fails with error: initializer element is not constant"
  end

  def install
    args = ["--prefix=#{prefix}"]
    args << "--with-x" if build.with? 'x'

    unless build.head?
      # Cairo & Python are still optional in stable, but not in HEAD.
      args << "--without-cairo" if build.without? "cairo"
      args << "--disable-python-extension" if build.without? "python"
      args << "--disable-python-scripting" if build.without? "python"
    end

    # Fix linker error; see: http://trac.macports.org/ticket/25012
    ENV.append "LDFLAGS", "-lintl"

    # Add environment variables for system libs
    ENV.append "ZLIB_CFLAGS", "-I/usr/include"
    ENV.append "ZLIB_LIBS", "-L/usr/lib -lz"

    # And finding Homebrew's Python
    if build.with? "python"
      ENV.append_path "PKG_CONFIG_PATH", "#{HOMEBREW_PREFIX}/Frameworks/Python.framework/Versions/2.7/lib/pkgconfig/"
      ENV.prepend "LDFLAGS", "-L#{%x(python-config --prefix).chomp}/lib"
    end

    # Reset ARCHFLAGS to match how we build
    ENV["ARCHFLAGS"] = "-arch #{MacOS.preferred_arch}"

    system "./autogen.sh" if build.stable?
    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"

    # Fix the broken fontforge_package_name issue
    # This is fixed in the HEAD build.
    if build.stable?
      mv "#{include}/fontforge_package_name", "#{include}/fontforge"
      mv "#{share}/fontforge_package_name", "#{share}/fontforge"
      mv "#{share}/doc/fontforge_package_name", "#{share}/doc/fontforge"
    end
  end

  test do
    system "#{bin}/fontforge", "-version"
  end
end
