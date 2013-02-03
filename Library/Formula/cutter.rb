require 'formula'

class Cutter < Formula
  homepage 'http://cutter.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/cutter/cutter/1.2.2/cutter-1.2.2.tar.gz'
  sha1 'ce33471d343af21488ad0f36c8ed4f4ab3f6cd72'

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'glib'
  depends_on 'gettext'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-glibtest",
                          "--disable-goffice",
                          "--disable-gstreamer",
                          "--disable-libsoup"
    system "make"
    system "make install"
  end
end
