require 'formula'

class DmtxUtils < Formula
  homepage 'http://www.libdmtx.org'
  url 'https://downloads.sourceforge.net/project/libdmtx/libdmtx/0.7.4/dmtx-utils-0.7.4.zip'
  sha1 '9c50506b420ed646e1554286de4daf7e9218f105'
  revision 1

  depends_on 'pkg-config' => :build
  depends_on 'libdmtx'
  depends_on 'imagemagick'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
