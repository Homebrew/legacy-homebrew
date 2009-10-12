require 'brewkit'

class Speex <Formula
  url 'http://downloads.us.xiph.org/releases/speex/speex-1.0.5.tar.gz'
  homepage 'http://speex.org'
  md5 '01d6a2de0a88a861304bf517615dea79'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
