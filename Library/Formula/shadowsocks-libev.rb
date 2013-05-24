require 'formula'

class ShadowsocksLibev < Formula
  homepage 'https://github.com/madeye/shadowsocks-libev'
  url 'https://github.com/madeye/shadowsocks-libev.git', :using => :git, :revision => '8fe783e434adc7bb0949855c31a7dabb257b0bda'
  version '1.3'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def test
      system "ls #{bin}/ss-local"
  end
end
