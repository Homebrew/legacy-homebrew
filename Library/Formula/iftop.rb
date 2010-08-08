require 'formula'

class Iftop <Formula
  url 'http://www.ex-parrot.com/~pdw/iftop/download/iftop-0.17.tar.gz'
  homepage 'http://www.ex-parrot.com/~pdw/iftop/'
  md5 '062bc8fb3856580319857326e0b8752d'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
