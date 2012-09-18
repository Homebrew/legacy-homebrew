require 'formula'

class Monit < Formula
  homepage 'http://mmonit.com/monit/'
  url 'http://mmonit.com/monit/dist/monit-5.4.tar.gz'
  sha256 '805c6545de2dd7f3d9e6e0c68018b2aadd5fc98b243c8868178f247a60906038'

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
