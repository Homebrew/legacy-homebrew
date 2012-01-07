require 'formula'

class TaLib < Formula
  url 'http://sourceforge.net/projects/ta-lib/files/ta-lib/0.4.0/ta-lib-0.4.0-src.tar.gz'
  homepage 'http://ta-lib.org/index.html'
  md5 '308e53b9644213fc29262f36b9d3d9b9'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
    bin.install ['src/tools/ta_regtest/.libs/ta_regtest']
  end

  def test
    system "#{bin}/ta_regtest"
  end
end
