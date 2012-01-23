require 'formula'

class Monit < Formula
  url 'http://mmonit.com/monit/dist/monit-5.3.1.tar.gz'
  homepage 'http://mmonit.com/monit/'
  sha256 '91a3f15c11a9b9e60e6e3b963f9f4af2acf5ca50ac6dc047d94ce50e966addc6'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}/monit",
                          "--sysconfdir=#{etc}/monit"
    system "make install"
  end

  def test
    system "monit -h"
  end
end
