require 'formula'

class Discount <Formula
  url 'https://github.com/Orc/discount/tarball/v2.0.4'
  homepage 'http://www.pell.portland.or.us/~orc/Code/markdown/'
  md5 'a6f8ddefaecd1f88f522fc4e7da7efdb'

  def install
    system "./configure.sh", "--prefix=#{prefix}", "--mandir=#{man}",
                             "--enable-dl-tag", "--enable-all-features"
    bin.mkdir
    lib.mkdir
    include.mkdir
    system "make install.everything"
  end
end
