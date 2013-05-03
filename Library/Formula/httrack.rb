require 'formula'

class Httrack < Formula
  homepage 'http://www.httrack.com/'
  url 'http://download.httrack.com/httrack-3.47.7.tar.gz'
  sha1 '324ead01e873c5fdff7305ba9194d920300ba136'

  def install
    ENV.deparallelize
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
    # Don't need Gnome integration
    rm_rf share+'applications'
    rm_rf share+'pixmaps'
  end
end
