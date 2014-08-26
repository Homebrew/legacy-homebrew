require "formula"

class Httrack < Formula
  homepage "http://www.httrack.com/"
  # Always use mirror.httrack.com when you link to a new version of HTTrack, as
  # link to download.httrack.com will break on next HTTrack update.
  url "http://mirror.httrack.com/historical/httrack-3.48.19.tar.gz"
  sha1 "7df386a248444c599948dbc77ed705b101151ed4"

  def install
    ENV.deparallelize
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
    # Don't need Gnome integration
    rm_rf Dir["#{share}/{applications,pixmaps}"]
  end
end
