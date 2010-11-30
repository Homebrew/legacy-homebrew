require 'formula'

class Discount <Formula
  url 'https://github.com/Orc/discount/tarball/v2.0.3'
  homepage 'http://www.pell.portland.or.us/~orc/Code/markdown/'
  md5 '80e304710fa8806d48770342853f35b6'

  def install
    system "./configure.sh", "--prefix=#{prefix}", "--mandir=#{man}",
                             "--enable-dl-tag", "--enable-all-features"
    bin.mkdir
    lib.mkdir
    include.mkdir
    system "make install.everything"
  end
end
