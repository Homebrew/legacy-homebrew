require 'formula'

class Cutter < Formula
  homepage 'http://cutter.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/cutter/cutter/1.2.3/cutter-1.2.3.tar.gz'
  sha1 '97446319f0a4892433912ab91633b6e0ffa2d09c'

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
