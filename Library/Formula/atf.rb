require 'formula'

class Atf < Formula
  homepage 'http://code.google.com/p/kyua/wiki/ATF'
  url 'https://kyua.googlecode.com/files/atf-0.18.tar.gz'
  sha1 '2dedc4472e0cd8b30cb54d3c96984ed7a0a1c61c'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system 'make'
    ENV.j1
    system 'make install'
  end
end
