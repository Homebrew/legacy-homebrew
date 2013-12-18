require 'formula'

class Monit < Formula
  homepage 'http://mmonit.com/monit/'
  url 'http://mmonit.com/monit/dist/monit-5.6.tar.gz'
  sha256 '38e09bd8b39abc59e6b9a9bb7a78f7eac2b02a92f4de1f3a6dc24e84dfedae0d'

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
