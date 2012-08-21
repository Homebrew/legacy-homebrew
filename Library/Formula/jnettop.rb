require 'formula'

class Jnettop < Formula
  homepage 'http://jnettop.kubs.info/'
  url 'http://jnettop.kubs.info/dist/jnettop-0.13.0.tar.gz'
  sha1 '59f4c28db6f8b1c58050d72aaa4b3b6d5a4a75e0'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "jnettop"
  end
end
