require 'formula'

class Freetype <Formula
  url 'http://mirror.dknss.com/nongnu/freetype/freetype-2.3.9.tar.gz'
  homepage 'http://freetype.sourceforge.net'
  md5 '9c2744f1aa72fe755adda33663aa3fad'

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
