require 'formula'

class Jack <Formula
  url 'http://jackaudio.org/downloads/jack-audio-connection-kit-0.118.0.tar.gz'
  homepage 'http://jackaudio.org'
  md5 'd58e29a55f285d54e75134cec8e02a10'

  depends_on 'pkg-config'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
