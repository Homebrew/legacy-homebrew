require 'formula'

class Discount < Formula
  homepage 'http://www.pell.portland.or.us/~orc/Code/discount/'
  url 'http://www.pell.portland.or.us/~orc/Code/discount/discount-2.1.6.tar.bz2'
  sha1 'a7461731613d0e2f88dd19af9feb860c191e8234'

  conflicts_with 'markdown',
    :because => 'both discount and markdown ship a `markdown` executable.'

  def install
    system "./configure.sh", "--prefix=#{prefix}",
                             "--mandir=#{man}",
                             "--with-dl=Both",
                             "--enable-all-features"
    bin.mkpath
    lib.mkpath
    include.mkpath
    system "make install.everything"
  end
end
