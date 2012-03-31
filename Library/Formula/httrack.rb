require 'formula'

class Httrack < Formula
  homepage 'http://www.httrack.com/'
  url 'http://download.httrack.com/httrack-3.45.3.tar.gz'
  md5 'd053e0f5ce8483313d37bb6adf00fad0'

  def install
    ENV.deparallelize
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-shared=no"
    system "make install"
    # Don't need Gnome integration
    rm_rf share+'applications'
    rm_rf share+'pixmaps'
  end
end
