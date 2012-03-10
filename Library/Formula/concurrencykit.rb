require 'formula'

class Concurrencykit < Formula
  url 'http://concurrencykit.org/releases/ck-0.1.4.tar.gz'
  homepage 'http://concurrencykit.org'
  md5 '11f6f2145d12c48fd17845b39f492ceb'
  head 'git://git.concurrencykit.org/ck.git'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
