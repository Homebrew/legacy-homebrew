require 'formula'

class Libsodium < Formula
  homepage 'https://github.com/jedisct1/libsodium/'
  url 'http://download.dnscrypt.org/libsodium/releases/libsodium-0.4.2.tar.gz'
  sha1 '7654452a6433d4bee985505be5d338e137e6fba0'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make check"
    system "make install"
  end
end
