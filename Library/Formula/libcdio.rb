require 'formula'

class Libcdio < Formula
  homepage 'http://www.gnu.org/software/libcdio/'
  url 'http://ftpmirror.gnu.org/libcdio/libcdio-0.83.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/libcdio/libcdio-0.83.tar.gz'
  sha1 '43f55972b23fd196d15fd6db17354a1d28e2bb24'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
