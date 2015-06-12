class Freetype < Formula
  desc "Software library to render fonts"
  homepage "http://www.freetype.org"
  url "https://downloads.sf.net/project/freetype/freetype2/2.6/freetype-2.6.tar.bz2"
  mirror "http://download.savannah.gnu.org/releases/freetype/freetype-2.6.tar.bz2"
  sha256 "8469fb8124764f85029cc8247c31e132a2c5e51084ddce2a44ea32ee4ae8347e"

  bottle do
    cellar :any
    sha1 "f3c9868e2f0cad854d1f24c5dcc98e304ce9c59e" => :yosemite
    sha1 "c2cab6b497af1b07ce940139bb7dec65c8a2117c" => :mavericks
    sha1 "341bb165aa5c67cecace843be154ef71723d6268" => :mountain_lion
  end

  keg_only :provided_pre_mountain_lion

  option :universal
  option "without-subpixel", "Disable sub-pixel rendering (a.k.a. LCD rendering, or ClearType)"

  depends_on "libpng"

  def install
    if build.with? "subpixel"
      inreplace "include/config/ftoption.h",
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
