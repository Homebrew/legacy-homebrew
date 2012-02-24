require 'formula'

class Discount < Formula
  url 'https://github.com/Orc/discount/tarball/v2.1.3'
  homepage 'http://www.pell.portland.or.us/~orc/Code/discount/'
  md5 '0c6db0556506724dac050ec19ab625b5'

  def install
    system "./configure.sh", "--prefix=#{prefix}", "--mandir=#{man}",
                             "--with-dl=Both", "--enable-all-features"
    bin.mkdir
    lib.mkdir
    include.mkdir
    system "make install.everything"
  end
end
