class Freetype < Formula
  desc "Software library to render fonts"
  homepage "http://www.freetype.org"
  url "https://downloads.sf.net/project/freetype/freetype2/2.6.1/freetype-2.6.1.tar.bz2"
  mirror "http://download.savannah.gnu.org/releases/freetype/freetype-2.6.1.tar.bz2"
  sha256 "2f6e9a7de3ae8e85bdd2fe237e27d868d3ba7a27495e65906455c27722dd1a17"

  bottle do
    cellar :any
    sha256 "9ae2440ca6511e63e18d723a0a6866e978883297e835322498c7bfd451bf435f" => :el_capitan
    sha256 "79aa27a0e5416cde4d866a5283fa5b8a9ff1b5c920128edc20ac2f482900d083" => :yosemite
    sha256 "da9a3df9c363f2b27d7a3a823e39fe54e37f8a0090a4377967b0dbe965b2475f" => :mavericks
    sha256 "40c36d3383dcc14e27cea0d80b5020d252e7ac9c3e100b725ac3649ef04fe57c" => :mountain_lion
  end

  keg_only :provided_pre_mountain_lion

  option :universal
  option "without-subpixel", "Disable sub-pixel rendering (a.k.a. LCD rendering, or ClearType)"

  depends_on "libpng"
  depends_on "coreutils" => :build

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
