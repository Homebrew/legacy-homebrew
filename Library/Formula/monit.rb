require 'formula'

class Monit < Formula
  url 'http://mmonit.com/monit/dist/monit-5.3.2.tar.gz'
  homepage 'http://mmonit.com/monit/'
  sha256 '406a06ac912525c8e76066d07235c848466b331532b2b3de931b61fe455ae915'

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
