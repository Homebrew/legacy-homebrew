class Freetype < Formula
  desc "Software library to render fonts"
  homepage "http://www.freetype.org"
  url "https://downloads.sf.net/project/freetype/freetype2/2.6/freetype-2.6.tar.bz2"
  mirror "http://download.savannah.gnu.org/releases/freetype/freetype-2.6.tar.bz2"
  sha256 "8469fb8124764f85029cc8247c31e132a2c5e51084ddce2a44ea32ee4ae8347e"
  revision 1

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

  # Don't define a TYPEOF macro in ftconfig.h
  # https://savannah.nongnu.org/bugs/index.php?45376
  # http://git.savannah.gnu.org/cgit/freetype/freetype2.git/commit/?id=5931268eecaeda3e05580bdc8885348fecc43fa8
  patch do
    url "https://gist.githubusercontent.com/anonymous/b47d77c41a6801879fd2/raw/fc21c3516b465095da7ed13f98bea491a7d18bbd/patch"
    sha256 "5b21575d0384c9e502b51b0ba4be0ff453a34bcf9deba52b6baa38c3ffcde063"
  end

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
