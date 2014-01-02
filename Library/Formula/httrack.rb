require 'formula'

class Httrack < Formula
  homepage 'http://www.httrack.com/'
  # url: Always use mirror.httrack.com when you link to a new version
  # of HTTrack, as link to download.httrack.com will break on next
  # HTTrack update.
  url 'http://mirror.httrack.com/historical/httrack-3.47.27.tar.gz'
  sha1 'cae1c6c02d2c59dc62e7abdbc6240414b764d292'

  def install
    ENV.deparallelize
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
    # Don't need Gnome integration
    rm_rf share+'applications'
    rm_rf share+'pixmaps'
  end
end
