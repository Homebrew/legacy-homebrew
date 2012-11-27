require 'formula'

class Libcdio < Formula
  homepage 'http://www.gnu.org/software/libcdio/'
  url 'http://ftpmirror.gnu.org/libcdio/libcdio-0.90.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/libcdio/libcdio-0.90.tar.gz'
  sha1 '68121536111f9ccf0b42fc1ef79abaa6f91b8299'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
