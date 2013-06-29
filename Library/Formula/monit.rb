require 'formula'

class Monit < Formula
  homepage 'http://mmonit.com/monit/'
  url 'http://mmonit.com/monit/dist/monit-5.5.1.tar.gz'
  sha256 'dbe4b4744a7100e2d5f4eac353dfb2df0549848e2c7661d9c19acc31cdef2c78'

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
