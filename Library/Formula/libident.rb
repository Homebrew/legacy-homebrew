require 'formula'

class Libident < Formula
  homepage 'http://www.remlab.net/libident/'
  url 'http://www.remlab.net/files/libident/libident-0.32.tar.gz'
  sha1 '4658807b017f21928a64f3442ee3a2b91f48d14e'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
