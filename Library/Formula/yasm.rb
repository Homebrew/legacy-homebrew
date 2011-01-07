require 'formula'

class Yasm <Formula
  url 'http://www.tortall.net/projects/yasm/releases/yasm-1.1.0.tar.gz'
  homepage 'http://www.tortall.net/projects/yasm/'
  md5 '8392e5f2235c2c2a981e1a633f2698cb'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
