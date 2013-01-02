require 'formula'

class Gifsicle < Formula
  homepage 'http://www.lcdf.org/gifsicle/'
  url 'http://www.lcdf.org/gifsicle/gifsicle-1.67.tar.gz'
  sha1 '9b239cfce086d416017b237743d68d19a3a095f6'

  depends_on :x11

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-all"
    system "make install"
  end
end
