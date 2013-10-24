require 'formula'

class Owamp < Formula
  homepage 'http://www.internet2.edu/performance/owamp/'
  url 'http://software.internet2.edu/sources/owamp/owamp-3.3.tar.gz'
  sha1 'ac3b77294ee30d41924b01fc009de0b2605a753c'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
