require 'formula'

class Discount < Formula
  url 'https://github.com/Orc/discount/tarball/v2.0.9'
  homepage 'http://www.pell.portland.or.us/~orc/Code/markdown/'
  md5 '3190e8f3d4a607537faa4ccc3d92ea6d'

  def install
    system "./configure.sh", "--prefix=#{prefix}", "--mandir=#{man}",
                             "--with-dl=Both", "--enable-all-features"
    bin.mkdir
    lib.mkdir
    include.mkdir
    system "make install.everything"
  end
end
