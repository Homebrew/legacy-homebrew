require 'formula'

class Discount <Formula
  url 'https://github.com/Orc/discount/tarball/v2.0.8'
  homepage 'http://www.pell.portland.or.us/~orc/Code/markdown/'
  md5 '36b3abee3f3c7b370555f353b80857df'

  def install
    system "./configure.sh", "--prefix=#{prefix}", "--mandir=#{man}",
                             "--with-dl=Both", "--enable-all-features"
    bin.mkdir
    lib.mkdir
    include.mkdir
    system "make install.everything"
  end
end
