class Fontforge < Formula
  homepage "https://fontforge.github.io"
  url "https://github.com/fontforge/fontforge/archive/20150228.tar.gz"
  sha256 "5b4e66159856da0e231488f8e6d508ec158ba9cc6892ec34a491f469debedc20"
  head "https://github.com/fontforge/fontforge.git"

  bottle do
    sha1 "5cdcd9ec8f1679a9285b3b85a8c063fd7a1c7153" => :yosemite
    sha1 "25382df7037e07d8cd72d10ac42657699d5005e1" => :mavericks
    sha1 "b13d67164ecdad117681234e3dd9386ab7611671" => :mountain_lion
  end

  option "with-giflib", "Build with GIF support"

  deprecated_option "with-x" => "with-x11"
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
  depends_on "fontconfig"
  depends_on "cairo"
  depends_on "libpng" => :recommended
  depends_on "jpeg" => :recommended
  depends_on "libtiff" => :recommended
  depends_on "giflib" => :optional
  depends_on "libspiro" => :optional
  depends_on :x11 => :optional
  depends_on :python if MacOS.version <= :snow_leopard

  fails_with :llvm do
    build 2336
    cause "Compiling cvexportdlg.c fails with error: initializer element is not constant"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-silent-rules
      --disable-dependency-tracking
    ]

    if build.with? "x11"
      args << "--with-x"
    else
      args << "--without-x"
    end

    args << "--without-libpng" if build.without? "libpng"
    args << "--without-libjpeg" if build.without? "jpeg"
    args << "--without-libtiff" if build.without? "libtiff"
    args << "--without-giflib" if build.without? "giflib"
    args << "--without-libspiro" if build.without? "libspiro"

    # Fix linker error; see: http://trac.macports.org/ticket/25012
    ENV.append "LDFLAGS", "-lintl"

    # And finding Homebrew's Python
    ENV.append_path "PKG_CONFIG_PATH", "#{HOMEBREW_PREFIX}/Frameworks/Python.framework/Versions/2.7/lib/pkgconfig/"
    ENV.prepend "LDFLAGS", "-L#{%x(python-config --prefix).chomp}/lib"

    # Reset ARCHFLAGS to match how we build
    ENV["ARCHFLAGS"] = "-arch #{MacOS.preferred_arch}"

    # Bootstrap in every build: https://github.com/fontforge/fontforge/issues/1806
    system "./bootstrap"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def post_install
    # Link this to enable symlinking into /Applications with brew linkapps.
    # The name is case-sensitive. It breaks without both F's capitalised.
    # If you build with x11 now, it automatically creates an dynamic link from bin/fontforge
    # to @executable_path/../Frameworks/Breakpad.framework/Versions/A/Breakpad which
    # obviously doesn't exist given fontforge and FontForge.app are in different places.
    # If this isn't fixed within a couple releases, consider dumping everything in libexec.
    # https://github.com/fontforge/fontforge/issues/2022
    if build.with? "x11"
      ln_s "#{share}/fontforge/osx/FontForge.app", prefix
      system "install_name_tool", "-change", "@executable_path/../Frameworks/Breakpad.framework/Versions/A/Breakpad",
             "#{bin}/fontforge", "#{share}/fontforge/osx/FontForge.app/Contents/Frameworks/Breakpad.framework/Versions/A/Breakpad"
    end
  end

  test do
    system bin/"fontforge", "-version"
  end
end
