require 'formula'

class ShadowsocksLibev < Formula
  homepage 'https://github.com/madeye/shadowsocks-libev'
  url 'https://github.com/madeye/shadowsocks-libev.git', :using => :git, :revision => '7288df7c844f837f9d943b8abc4e660396e7f0ef'
  version '1.2'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def test
      system "ls #{bin}/ss-local"
  end
end
