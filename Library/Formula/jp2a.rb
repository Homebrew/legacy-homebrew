require 'formula'

class Jp2a < Formula
  url 'http://sourceforge.net/projects/jp2a/files/jp2a/1.0.6/jp2a-1.0.6.tar.gz'
  homepage 'http://csl.sublevel3.org/jp2a/'
  md5 'eb6281eee29acf1c494dcaf7d745a5df'

  depends_on 'jpeg'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/jp2a", "-V"
  end
end
