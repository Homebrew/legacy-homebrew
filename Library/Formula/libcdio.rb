require 'formula'

class Libcdio < Formula
  homepage 'http://www.gnu.org/software/libcdio/'
  url 'http://ftpmirror.gnu.org/libcdio/libcdio-0.91.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/libcdio/libcdio-0.91.tar.gz'
  sha1 '898ae74c3cb78ea1afbb0a387fd0eedee999327b'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
