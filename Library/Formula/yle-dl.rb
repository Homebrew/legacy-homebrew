require 'formula'

class YleDl < Formula
  homepage 'http://aajanki.github.io/yle-dl/'
  url 'https://github.com/aajanki/yle-dl/archive/2.3.1.tar.gz'
  sha1 '5ec3516db2a5ecd793223636e27ed0c23657b575'

  head 'https://github.com/aajanki/yle-dl.git'

  depends_on 'rtmpdump'
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "pycrypto" => [:python, "Crypto"]

  def install
    system "make", "install", "SYS=darwin", "prefix=#{prefix}", "mandir=#{man}"
  end

  test do
    assert_match /rtmpdump: This program dumps the media content streamed over RTMP/,
      `#{bin}/yle-dl --help 2>&1`.strip
  end
end
