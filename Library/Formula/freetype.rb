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
    sha256 "193b5654ebf82f4b7a93135d57f033ae356a377570c6ae57181dc7c3871814fc" => :el_capitan
    sha256 "5bba28cde0019c646301ae043612310c1cf61ff601a6929879316ef5f9fbf875" => :yosemite
    sha256 "3a7351d858dd686cc1611527ef2f5788a2cf85f5ef9b922e50b413d62872fe40" => :mavericks
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
