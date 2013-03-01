require 'formula'

class Monit < Formula
  homepage 'http://mmonit.com/monit/'
  url 'http://mmonit.com/monit/dist/monit-5.5.tar.gz'
  sha256 '8276b060b3f0e6453c9748d421dec044ddae09d3e4c4666e13472aab294d7c53'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}/monit",
                          "--sysconfdir=#{etc}/monit"
    system "make install"
  end

  def test
    system "#{bin}/monit", "-h"
  end
end
