require 'formula'

class Discount < Formula
  url 'https://github.com/Orc/discount/tarball/v2.1.1.3'
  homepage 'http://www.pell.portland.or.us/~orc/Code/discount/'
  md5 'd0bbf99e863e993a0c6861a4ac310a2e'

  def install
    system "./configure.sh", "--prefix=#{prefix}", "--mandir=#{man}",
                             "--with-dl=Both", "--enable-all-features"
    bin.mkdir
    lib.mkdir
    include.mkdir
    system "make install.everything"
  end
end
