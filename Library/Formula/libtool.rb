require 'formula'

class Libtool < Formula
  url      'http://ftpmirror.gnu.org/libtool/libtool-2.4.2.tar.gz'
  homepage 'http://www.gnu.org/software/libtool/'
  md5      'd2f3b7d4627e69e13514a40e72a24d50'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "test -f #{HOMEBREW_PREFIX}/lib/libltdl.dylib"
  end
end
