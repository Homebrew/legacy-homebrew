class Freetype < Formula
  desc "Software library to render fonts"
  homepage "http://www.freetype.org"
  url "https://downloads.sf.net/project/freetype/freetype2/2.6.3/freetype-2.6.3.tar.bz2"
  mirror "http://download.savannah.gnu.org/releases/freetype/freetype-2.6.3.tar.bz2"
  sha256 "371e707aa522acf5b15ce93f11183c725b8ed1ee8546d7b3af549863045863a2"

  # Note: when bumping freetype's version, you must also bump revisions of formula with
  # "full path" references to freetype in their pkgconfig.
  # See https://github.com/Homebrew/homebrew/pull/44587

  bottle do
    cellar :any
    sha256 "03d81469f42b34176ad9b7a382a2ab613445541a57e3db02e80121508cc43309" => :el_capitan
    sha256 "ff8df778e420e76ac823fb5d31b3bfd1d89be87aa664bb1140bb44508f4d5e23" => :yosemite
    sha256 "ecfb1b9f4dcce361d4c40367dc205842411cbcbb6628238da571aff84caf05c3" => :mavericks
  end

  keg_only :provided_pre_mountain_lion

  option :universal
  option "without-subpixel", "Disable sub-pixel rendering (a.k.a. LCD rendering, or ClearType)"

  depends_on "libpng"

  def install
    if build.with? "subpixel"
      inreplace "include/freetype/config/ftoption.h",
          "/* #define FT_CONFIG_OPTION_SUBPIXEL_RENDERING */",
          "#define FT_CONFIG_OPTION_SUBPIXEL_RENDERING"
    end

    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}", "--without-harfbuzz"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/freetype-config", "--cflags", "--libs", "--ftversion",
      "--exec-prefix", "--prefix"
  end
end
