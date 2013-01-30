require 'formula'

class Libsodium < Formula
  homepage 'https://github.com/jedisct1/libsodium'
  url 'http://download.dnscrypt.org/libsodium/releases/libsodium-0.2.tar.gz'
  sha1 'd1257c72c826a3715d7bf5241c227fb78d8ede45'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make check"
    system "make install"
  end
end
