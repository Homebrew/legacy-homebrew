require 'formula'

class Rlwrap <Formula
  url 'http://utopia.knoware.nl/~hlub/rlwrap/rlwrap-0.33.tar.gz'
  md5 '831f375ca6c9d7ac77bebff616bd03a6'
  homepage 'http://utopia.knoware.nl/~hlub/rlwrap/'

  depends_on 'readline'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
