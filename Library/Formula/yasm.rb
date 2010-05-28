require 'formula'

class Yasm <Formula
  url 'http://www.tortall.net/projects/yasm/releases/yasm-1.0.1.tar.gz'
  homepage 'http://www.tortall.net/projects/yasm/'
  md5 '2174fc3b6b74de07667f42d47514c336'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
