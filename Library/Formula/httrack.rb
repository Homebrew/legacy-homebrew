require 'formula'

class Httrack < Formula
  homepage 'http://www.httrack.com/'
  url 'http://download.httrack.com/httrack-3.44.5.tar.gz'
  md5 '6cbe14751a68b664223e70a2e88273d2'

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
