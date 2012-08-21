require 'formula'

class Xorriso < Formula
  homepage 'http://www.gnu.org/software/xorriso/'
  url 'http://www.gnu.org/software/xorriso/xorriso-1.2.4.tar.gz'
  sha1 'd74099b263fa34ad08bb6f9f1d68f4666391188d'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/xorriso", "--help"
  end
end
