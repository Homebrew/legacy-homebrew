require 'formula'

class Httrack < Formula
  homepage 'http://www.httrack.com/'
  # url: Always use mirror.httrack.com when you link to a new version
  # of HTTrack, as link to download.httrack.com will break on next
  # HTTrack update.
  url 'http://mirror.httrack.com/historical/httrack-3.48.14.tar.gz'
  sha1 'f764290fa4394bd5035bfebde6b05b2d54c662f9'

  def install
    ENV.deparallelize
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
    # Don't need Gnome integration
    rm_rf share+'applications'
    rm_rf share+'pixmaps'
  end
end
