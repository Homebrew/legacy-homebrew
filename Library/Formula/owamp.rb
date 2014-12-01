require 'formula'

class Owamp < Formula
  homepage 'http://www.internet2.edu/performance/owamp/'
  url 'http://software.internet2.edu/sources/owamp/owamp-3.3.tar.gz'
  sha1 'ac3b77294ee30d41924b01fc009de0b2605a753c'

  # Fix to prevent tests hanging under certain circumstances.
  # Provided by Aaron Brown via perfsonar-user mailing list:
  # https://lists.internet2.edu/sympa/arc/perfsonar-user/2014-11/msg00131.html
  patch do
    url "http://ndb1.internet2.edu/~aaron/owamp_time_fix.patch"
    sha1 "9e5588d57b357f438ae1a785a713f0deaea5a5ba"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
