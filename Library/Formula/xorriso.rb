require 'formula'

class Xorriso < Formula
  homepage 'http://www.gnu.org/software/xorriso/'
  url 'http://ftpmirror.gnu.org/xorriso/xorriso-1.3.0.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/xorriso/xorriso-1.3.0.tar.gz'
  sha1 'f2c0a0af1f873ceb5a37c5294f4ea85c898af67b'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/xorriso", "--help"
  end
end
