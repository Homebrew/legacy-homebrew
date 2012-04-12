require 'formula'

class Yasm < Formula
  url 'http://www.tortall.net/projects/yasm/releases/yasm-1.2.0.tar.gz'
  homepage 'http://www.tortall.net/projects/yasm/'
  md5 '4cfc0686cf5350dd1305c4d905eb55a6'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
