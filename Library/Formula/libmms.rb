require 'formula'

class Libmms < Formula
  homepage 'http://sourceforge.net/projects/libmms/'
  url 'https://downloads.sourceforge.net/project/libmms/libmms/0.6.2/libmms-0.6.2.tar.gz'
  sha1 'cdef62fd1a0e2585dd2111fc94b032f84290e351'

  depends_on 'pkg-config' => :build
  depends_on 'glib'

  # https://trac.macports.org/ticket/27988
  patch :p0 do
    url "https://trac.macports.org/export/87883/trunk/dports/multimedia/libmms/files/src_mms-common.h.patch"
    sha1 "57b526dc9de76cfde236d3331e18eb7ae92f999f"
  end if MacOS.version <= :leopard

  def install
    ENV.append 'LDFLAGS', '-liconv'
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
