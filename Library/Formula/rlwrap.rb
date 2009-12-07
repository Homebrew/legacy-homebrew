require 'formula'

class Rlwrap <Formula
  url 'http://utopia.knoware.nl/~hlub/uck/rlwrap/rlwrap-0.32.tar.gz'
  homepage 'http://utopia.knoware.nl/~hlub/uck/rlwrap'
  md5 '441282a9a65c1d516c1c9a6821184539'

  depends_on 'readline'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
