require 'formula'

class Httrack <Formula
  url 'http://download.httrack.com/cserv.php3?File=httrack.tar.gz'
  homepage 'http://www.httrack.com/'
  md5 '065d2d7d37e99ab788fe4968bc947ac8'
  version '3.43-9D'

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
