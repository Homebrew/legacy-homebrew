require 'formula'

class Freetype < Formula
  homepage 'http://www.freetype.org'
  url 'https://downloads.sf.net/project/freetype/freetype2/2.5.3/freetype-2.5.3.tar.bz2'
  sha1 'd3c26cc17ec7fe6c36f4efc02ef92ab6aa3f4b46'
  revision 1

  bottle do
    cellar :any
    revision 1
    sha1 "f31e54b32a34a69998e120706ba13a99a948c190" => :mavericks
    sha1 "d2f7099c87fe2dc8e969337326f1fe3036d4874e" => :mountain_lion
    sha1 "df246259dde3352bac99dc08af757604c06a2e09" => :lion
  end

  keg_only :provided_pre_mountain_lion

  option :universal
  option 'without-subpixel', "Disable sub-pixel rendering (a.k.a. LCD rendering, or ClearType)"

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
    system "#{bin}/freetype-config", '--cflags', '--libs', '--ftversion',
      '--exec-prefix', '--prefix'
  end
end
