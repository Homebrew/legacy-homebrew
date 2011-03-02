require 'formula'

class Discount <Formula
  url 'https://github.com/Orc/discount/tarball/v2.0.8'
  homepage 'http://www.pell.portland.or.us/~orc/Code/markdown/'
  md5 'e324e45c607bf2a2cdae13c76950aef6'

  def install
    system "./configure.sh", "--prefix=#{prefix}", "--mandir=#{man}",
                             "--with-dl=Both", "--enable-all-features"
    bin.mkdir
    lib.mkdir
    include.mkdir
    system "make install.everything"
  end
end
