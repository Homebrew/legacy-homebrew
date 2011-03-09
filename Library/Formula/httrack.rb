require 'formula'

class Httrack <Formula
  url 'http://download.httrack.com/cserv.php3?File=httrack.tar.gz'
  homepage 'http://www.httrack.com/'
  md5 '7aaf56913388adfdba506c346c2ca020'
  version '3.44.1'

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
