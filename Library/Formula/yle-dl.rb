require 'formula'

class YleDl < Formula
  homepage 'http://aajanki.github.io/yle-dl/'
  url 'https://github.com/aajanki/yle-dl/archive/2.1.0.tar.gz'
  sha1 'c2c05e3693737e864c4b296de022dc016c9f6865'

  head 'https://github.com/aajanki/yle-dl.git'

  depends_on 'rtmpdump'
  depends_on :python => ['Crypto' => 'pycrypto']

  def install
    system "make", "install", "SYS=darwin", "prefix=#{prefix}", "mandir=#{man}"
  end

  test do
    assert_match /rtmpdump: This program dumps the media content streamed over RTMP/,
      `#{bin}/yle-dl --help 2>&1`.strip
  end
end
