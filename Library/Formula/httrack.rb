require 'formula'

class Httrack <Formula
  url 'http://download.httrack.com/cserv.php3?File=httrack.tar.gz'
  homepage 'http://www.httrack.com/'
  md5 'd52539dfa39ee9bd2593ba44e2b3e149'
  version '3.43-9C'

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
