require 'formula'

class Rlwrap <Formula
  url 'http://utopia.knoware.nl/~hlub/rlwrap/rlwrap-0.36.tar.gz'
  md5 'f3d687658336789d5155322abcc84a7f'
  homepage 'http://utopia.knoware.nl/~hlub/rlwrap/'

  depends_on 'readline'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
