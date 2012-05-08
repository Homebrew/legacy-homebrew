require 'formula'

class Fastjar < Formula
  url 'https://downloads.sourceforge.net/project/fastjar/fastjar/0.94/fastjar-0.94.tar.gz'
  homepage 'http://sourceforge.net/projects/fastjar/'
  md5 '14d4bdfac236e347d806c6743dba48c6'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/fastjar -V"
    system "#{bin}/grepjar -V"
  end
end
