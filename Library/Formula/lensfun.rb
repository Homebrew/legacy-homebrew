require 'formula'

class Lensfun < Formula
  homepage 'http://lensfun.sourceforge.net/'
  head 'git://git.code.sf.net/p/lensfun/code'
  url 'https://downloads.sourceforge.net/project/lensfun/0.2.8/lensfun-0.2.8.tar.bz2'
  sha1 '0e85eb7692620668d27e2303687492ad68c90eb4'
  revision 1

  depends_on 'doxygen' => :optional
  depends_on 'glib'
  depends_on 'libpng'
  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
