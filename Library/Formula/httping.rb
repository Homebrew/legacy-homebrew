require 'formula'

class Httping < Formula
  url 'http://www.vanheusden.com/httping/httping-1.4.1.tgz'
  homepage 'http://www.vanheusden.com/httping/'
  md5 'bde1ff3c01343d2371d8f34fbf8a1d9a'

  def install
    system "make install PREFIX=#{prefix}"
  end
end
