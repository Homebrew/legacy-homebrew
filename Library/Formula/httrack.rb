require 'formula'

class Httrack < Formula
  homepage 'http://www.httrack.com/'
  url 'http://download.httrack.com/httrack-3.47.6.tar.gz'
  sha1 'bdf726de2b0838c9823dc4e77f4fb4791374ba44'

  def install
    ENV.deparallelize
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
    # Don't need Gnome integration
    rm_rf share+'applications'
    rm_rf share+'pixmaps'
  end
end
