require 'formula'

class ShadowsocksLibev < Formula
  homepage 'https://github.com/madeye/shadowsocks-libev'
  url 'https://github.com/madeye/shadowsocks-libev.git', :using => :git, :revision => '5b7f057663898b91e174b9440864f51474cc780d'
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
