require 'formula'

class Libmms < Formula
  url 'http://downloads.sourceforge.net/project/libmms/libmms/0.6.2/libmms-0.6.2.tar.gz'
  homepage 'http://sourceforge.net/projects/libmms/'
  sha1 'cdef62fd1a0e2585dd2111fc94b032f84290e351'

  depends_on 'pkg-config' => :build
  depends_on 'glib'

  def install
    ENV.append 'LDFLAGS', '-liconv'
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
