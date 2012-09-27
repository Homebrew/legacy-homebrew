require 'formula'

class OpenCobol < Formula
  url 'http://downloads.sourceforge.net/project/open-cobol/open-cobol/1.0/open-cobol-1.0.tar.gz'
  homepage 'http://www.opencobol.org/'
  sha1 '4c0930a74e92014317b2f237aaedc90acc2b72df'

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
