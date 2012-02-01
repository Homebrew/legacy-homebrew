require 'formula'

class Httrack < Formula
  url 'http://download.httrack.com/httrack-3.44.4.tar.gz'
  homepage 'http://www.httrack.com/'
  md5 '614b7124b887c543fc10545b994b2814'

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-shared=no"
    system "make install"
    # Don't need Gnome integration
    rm_rf share+'applications'
    rm_rf share+'pixmaps'
  end
end
