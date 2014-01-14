require 'formula'

class Libcdio < Formula
  homepage 'http://www.gnu.org/software/libcdio/'
  url 'http://ftpmirror.gnu.org/libcdio/libcdio-0.92.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/libcdio/libcdio-0.92.tar.gz'
  sha1 '530031897955729ddb7c850c183f234f7a6516b7'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
