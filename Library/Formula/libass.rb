require 'formula'

class Libass < Formula
  url 'http://libass.googlecode.com/files/libass-0.9.12.tar.gz'
  homepage 'http://code.google.com/p/libass/'
  md5 'b5566b0cc5fdb67edbe3bf1d069aaaab'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
