require 'formula'

class OpenCobol < Formula
  url 'http://downloads.sourceforge.net/project/open-cobol/open-cobol/1.0/open-cobol-1.0.tar.gz'
  homepage 'http://www.opencobol.org/'
  md5 '947e0d9c4ee7fa8f077ea4bca2f894e5'

  depends_on 'gmp'
  depends_on 'berkeley-db'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--infodir=#{info}"
    system "make install"
  end

  def test
    system "#{bin}/cobc", "--help"
  end
end
