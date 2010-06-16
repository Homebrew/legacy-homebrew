require 'formula'

class Elinks <Formula
  @homepage='http://elinks.or.cz/'
  @url='http://elinks.or.cz/download/elinks-0.11.7.tar.bz2'
  @md5='fcd087a6d2415cd4c6fd1db53dceb646'

  def install
    ENV.deparallelize
    fails_with_llvm
    ENV.delete('LD')
    system "./configure --prefix='#{prefix}'"
    system "make install"
  end
end
