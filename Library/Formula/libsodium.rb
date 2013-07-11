require 'formula'

class Libsodium < Formula
  homepage 'https://github.com/jedisct1/libsodium/'
  url 'http://download.dnscrypt.org/libsodium/releases/libsodium-0.4.2.tar.gz'
  sha256 '1a7901cdd127471724e854a8eb478247dc0ca67be549345c75fc6f2d4e05ed39'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make check"
    system "make install"
  end
end
