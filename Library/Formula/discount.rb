require 'formula'

class Discount <Formula
  url 'http://www.pell.portland.or.us/~orc/Code/markdown/discount-1.5.8.tar.gz'
  homepage 'http://www.pell.portland.or.us/~orc/Code/markdown/'
  md5 'b7a4900bedd2d75147b0b708fb6e16ed'

  def install
    system "./configure.sh", "--prefix=#{prefix}", "--mandir=#{man}"
    bin.mkdir
    lib.mkdir
    include.mkdir
    system "make install.everything"
  end
end
