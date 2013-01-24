require 'formula'

class Libsodium < Formula
  homepage 'https://github.com/jedisct1/libsodium'
  url 'http://download.dnscrypt.org/libsodium/releases/libsodium-0.1.tar.gz'
  sha1 'fe48c0628d60d9671fc6f4da2a04b3eb0f7ce8d2'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make check"
    system "make install"
  end
end
