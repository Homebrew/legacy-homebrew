require 'formula'

class Lightning < Formula
  homepage 'http://www.gnu.org/software/lightning/'
  url 'http://ftpmirror.gnu.org/lightning/lightning-2.0.4.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/lightning/lightning-2.0.4.tar.gz'
  sha1 '06982b859dd2322d5bd9e52e0aacebe741a98e6e'

  def install
    system "./configure","--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
