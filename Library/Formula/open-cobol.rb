require 'formula'

class OpenCobol < Formula
  homepage 'http://www.opencobol.org/'
  url 'http://sourceforge.net/projects/open-cobol/files/open-cobol/1.1/open-cobol-1.1.tar.gz'
  sha1 'a833f011cd0f56d0aa3d97a56258ddd5141b594c'

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
