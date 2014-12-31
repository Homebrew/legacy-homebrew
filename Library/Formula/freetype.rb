require 'formula'

class Freetype < Formula
  homepage 'http://www.freetype.org'
  url 'https://downloads.sf.net/project/freetype/freetype2/2.5.5/freetype-2.5.5.tar.bz2'
  sha1 '7b7460ef51a8fdb17baae53c6658fc1ad000a1c2'

  bottle do
    cellar :any
    sha1 "f4359a08667fa05b71e10ad32ef10015dfed432b" => :yosemite
    sha1 "5121b7819b0d4df955779f030f9afcb9ace6184d" => :mavericks
    sha1 "a9a1bc440a482fc050edb5234052a9468d9ab4fb" => :mountain_lion
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
