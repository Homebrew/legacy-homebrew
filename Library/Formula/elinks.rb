require 'formula'

class Elinks <Formula
  homepage 'http://elinks.or.cz/'
  url 'http://elinks.or.cz/download/elinks-0.11.7.tar.bz2'
  md5 'fcd087a6d2415cd4c6fd1db53dceb646'

  def install
    fails_with_llvm
    ENV.deparallelize
    ENV.delete('LD')
    system "./configure", "--prefix=#{prefix}", "--without-spidermonkey"
    system "make install"
  end
end
