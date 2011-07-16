require 'formula'

class Concurrencykit < Formula
  url 'http://concurrencykit.org/releases/ck-0.1.0.tar.gz'
  homepage 'http://concurrencykit.org'
  md5 '1832e4d0b7fb31a159d50ab3e66b8979'
  head 'git://git.concurrencykit.org/ck.git'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
