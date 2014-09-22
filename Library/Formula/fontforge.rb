require 'formula'

class Fontforge < Formula
  homepage "https://fontforge.github.io"

  stable do
    url "https://github.com/fontforge/fontforge/archive/2.0.20140101.tar.gz"
    sha1 "abce297e53e8b6ff6f08871e53d1eb0be5ab82e7"

    depends_on :python => :optional
  end

  bottle do
    sha1 "62e19f688ec4fbd4a6263c6187980c35521a7b40" => :mavericks
    sha1 "5edf50ab049d44ff399defe673faa58d136c54d3" => :mountain_lion
    sha1 "8b38be9b20ce239e63f3f3009482ab8f130c0a33" => :lion
  end

  head do
    url "https://github.com/fontforge/fontforge.git"

    depends_on "zeromq"
    depends_on "czmq"
    depends_on :python if MacOS.version <= :snow_leopard
  end

  option 'with-gif', 'Build with GIF support'
  option 'without-x', 'Build without X11 support, not building the app bundle'

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "ossp-uuid"
  depends_on "gettext"
  depends_on "pango"
  depends_on "cairo"
  depends_on "libpng"   => :recommended
  depends_on "jpeg"     => :recommended
  depends_on "libtiff"  => :recommended
  depends_on :x11  => :recommended
  depends_on "giflib" if build.with? 'gif'
  depends_on "libspiro" => :optional
  depends_on "fontconfig"

  fails_with :llvm do
    build 2336
    cause "Compiling cvexportdlg.c fails with error: initializer element is not constant"
  end

  def install
    args = ["--prefix=#{prefix}"]

    args << "--without-x" if build.without? 'x'

    if build.with? 'python'
      args << "--enable-pyextension"
      # Fix linking to correct Python library
      ENV.prepend "LDFLAGS", "-L#{%x(python-config --prefix).chomp}/lib"
    end

    # Fix linker error; see: http://trac.macports.org/ticket/25012
      ENV.append "LDFLAGS", "-lintl"

    # Add environment variables for system libs
      ENV.append "ZLIB_CFLAGS", "-I/usr/include"
      ENV.append "ZLIB_LIBS", "-L/usr/lib -lz"

    # Reset ARCHFLAGS to match how we build
    ENV["ARCHFLAGS"] = "-arch #{MacOS.preferred_arch}"

    system "./autogen.sh" if build.stable?
    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make"
    system "make install"

    # Fontforge stable is installed to an irregular location, and breaks the package.
    # To fix it, we move the irregular package name to the expected name.
    # This is fixed in the HEAD build.
    mv "#{share}/fontforge_package_name", "#{share}/fontforge" if build.stable?
  end

  def caveats
    "To launch the Fontforge app bundle run 'fontforge' in your shell"
  end

  test do
    system "#{bin}/fontforge", "-version"
  end
end
