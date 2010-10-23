require 'formula'

class Discount <Formula
  url 'http://github.com/Orc/discount/tarball/v2.0'
  homepage 'http://www.pell.portland.or.us/~orc/Code/markdown/'
  md5 'd911db94ba31a292940a80fdf0982302'

  def install
    system "./configure.sh", "--prefix=#{prefix}", "--mandir=#{man}",
                             "--enable-dl-tag", "--enable-all-features"
    bin.mkdir
    lib.mkdir
    include.mkdir
    system "make install.everything"
  end
end
