require 'formula'

class Monit < Formula
  url 'http://mmonit.com/monit/dist/monit-5.2.5.tar.gz'
  homepage 'http://mmonit.com/monit/'
  sha256 '3c2496e9f653ff8a46b75b61126a86cb3861ad35e4eeb7379d64a0fc55c1fd8d'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}/monit",
                          "--sysconfdir=#{etc}/monit"
    system "make install"
  end
end
