require 'formula'

class Discount <Formula
  url 'https://github.com/Orc/discount/tarball/v2.0.7'
  homepage 'http://www.pell.portland.or.us/~orc/Code/markdown/'
  md5 'fc8e18464abad30be8900b184c34f812'

  def install
    system "./configure.sh", "--prefix=#{prefix}", "--mandir=#{man}",
                             "--with-dl=Both", "--enable-all-features"
    bin.mkdir
    lib.mkdir
    include.mkdir
    system "make install.everything"
  end
end
