require 'formula'

class Lft < Formula
  homepage 'http://pwhois.org/lft/'
  url 'http://pwhois.org/dl/index.who?file=lft-3.35.tar.gz'
  sha1 'b6c6fb51f423c5398ca649b2e8cbcbe597afff23'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
