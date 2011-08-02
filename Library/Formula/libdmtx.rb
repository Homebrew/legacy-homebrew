require 'formula'

class Libdmtx < Formula
  url 'http://downloads.sourceforge.net/project/libdmtx/libdmtx/0.7.2/libdmtx-0.7.2.tar.bz2'
  homepage 'http://www.libdmtx.org'
  md5 '0684cf3857591e777b57248d652444ae'

  depends_on 'pkg-config' => :build
  depends_on 'imagemagick'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
