require 'formula'

class Httrack < Formula
  homepage 'http://www.httrack.com/'
  url 'http://download.httrack.com/httrack-3.45.4.tar.gz'
  md5 '3e5499d63f2fe777878515377fad077a'

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
