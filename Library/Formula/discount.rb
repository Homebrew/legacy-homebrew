require 'formula'

class Discount <Formula
  url 'http://github.com/Orc/discount/tarball/v2.0.1'
  homepage 'http://www.pell.portland.or.us/~orc/Code/markdown/'
  md5 '2495811dd9f68550a1464e4b6b00ac25'

  def install
    system "./configure.sh", "--prefix=#{prefix}", "--mandir=#{man}",
                             "--enable-dl-tag", "--enable-all-features"
    bin.mkdir
    lib.mkdir
    include.mkdir
    system "make install.everything"
  end
end
