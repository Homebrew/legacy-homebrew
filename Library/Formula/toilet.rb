require 'formula'

class Toilet <Formula
  url 'http://caca.zoy.org/raw-attachment/wiki/toilet/toilet-0.2.tar.gz'
  homepage 'http://caca.zoy.org/wiki/toilet'
  md5 '4dec7585a2a2d716a765d553cdc1ddaf'

  depends_on 'libcaca'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
