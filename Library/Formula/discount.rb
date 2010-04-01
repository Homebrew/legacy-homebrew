require 'formula'

class Discount <Formula
  url 'http://www.pell.portland.or.us/~orc/Code/markdown/discount-1.6.1.tar.gz'
  homepage 'http://www.pell.portland.or.us/~orc/Code/markdown/'
  md5 'f5a11aefb1906b28fc7532d0576d6a4a'

  def install
    system "./configure.sh", "--prefix=#{prefix}", "--mandir=#{man}"
    bin.mkdir
    lib.mkdir
    include.mkdir
    system "make install.everything"
  end
end
