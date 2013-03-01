require 'formula'

class Libdmtx < Formula
  homepage 'http://www.libdmtx.org'
  url 'http://downloads.sourceforge.net/project/libdmtx/libdmtx/0.7.4/libdmtx-0.7.4.tar.bz2'
  sha1 '016282df12c4046338b9ff73f3d8b39f023bae16'

  depends_on 'pkg-config' => :build
  depends_on 'imagemagick'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
