class Httrack < Formula
  homepage "http://www.httrack.com/"
  # Always use mirror.httrack.com when you link to a new version of HTTrack, as
  # link to download.httrack.com will break on next HTTrack update.
  url "http://mirror.httrack.com/historical/httrack-3.48.21.tar.gz"
  sha1 "a19564393ced4b2e22ab685201cbd5a1d6983930"

  depends_on "openssl"

  def install
    ENV.deparallelize
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
    # Don't need Gnome integration
    rm_rf Dir["#{share}/{applications,pixmaps}"]
  end
end
