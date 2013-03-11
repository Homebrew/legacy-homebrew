require 'formula'

class Libsodium < Formula
  homepage 'https://github.com/jedisct1/libsodium/'
  url 'http://download.dnscrypt.org/libsodium/releases/libsodium-0.3.tar.gz'
  sha1 '3d486dc40e7cbd9542d00088d3b73a719d7746fa'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make check"
    system "make install"
  end
end
