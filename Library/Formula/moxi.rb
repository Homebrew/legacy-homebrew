require 'formula'

class Moxi <Formula
  url 'http://labs.northscale.com/moxi/moxi-0.10.0.tar.gz'
  homepage 'http://labs.northscale.com/moxi/'
  md5 'ec73c7521324321eb4c8b4f51f9d7373'

  depends_on 'pkg-config'
  depends_on 'check'
  depends_on 'libevent'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
