require 'formula'

class Libsodium < Formula
  homepage 'https://github.com/jedisct1/libsodium/'
  url 'http://download.dnscrypt.org/libsodium/releases/libsodium-0.4.1.tar.gz'
  sha256 '65756c7832950401cc0e6ee0e99b165974244e749f40f33d465f56447bae8ce3'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make check"
    system "make install"
  end
end
