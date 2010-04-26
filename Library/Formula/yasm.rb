require 'formula'

class Yasm <Formula
  url 'http://www.tortall.net/projects/yasm/releases/yasm-1.0.0.tar.gz'
  homepage 'http://www.tortall.net/projects/yasm/'
  md5 'e00627e13d30ff9238053e95bd93a8fb'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
