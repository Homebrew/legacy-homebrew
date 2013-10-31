require 'formula'

class Xorriso < Formula
  homepage 'http://www.gnu.org/software/xorriso/'
  url 'http://ftpmirror.gnu.org/xorriso/xorriso-1.3.2.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/xorriso/xorriso-1.3.2.tar.gz'
  sha1 'e897e994ed01aa13070481adccfdf2a97044bdd4'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/xorriso", "--help"
  end
end
