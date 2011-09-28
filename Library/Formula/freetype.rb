require 'formula'

class Freetype < Formula
  url 'http://download.savannah.gnu.org/releases/freetype/freetype-2.3.12.tar.gz'
  homepage 'http://freetype.sourceforge.net'
  md5 '6fc690d9b34154b51a919ff466cea90c'

  keg_only :provided_by_osx,
    'The version of Freetype provided with Leopard is too old for some software'

  def options
    [["--native",
      "Enable native TrueType hinting, which is potentially covered by various Apple patents.\nSee: http://www.freetype.org/patents.html"]
    ]
  end

  def install
    if ARGV.include? "--native"
      inreplace "include/freetype/config/ftoption.h",
          "/* #define TT_CONFIG_OPTION_BYTECODE_INTERPRETER */",
          "#define TT_CONFIG_OPTION_BYTECODE_INTERPRETER"
    end

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
