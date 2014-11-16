require "formula"

class Httrack < Formula
  homepage "http://www.httrack.com/"
  # Always use mirror.httrack.com when you link to a new version of HTTrack, as
  # link to download.httrack.com will break on next HTTrack update.
  url "http://mirror.httrack.com/historical/httrack-3.48.19.tar.gz"
  sha1 "7df386a248444c599948dbc77ed705b101151ed4"

  # Fix building on systems without strnlen; fixed upstream, will be in next release
  # https://code.google.com/p/httrack/issues/detail?id=54
  patch :p0 do
    url "https://gist.githubusercontent.com/mistydemeo/5c50bba4be6c4f53d50c/raw/9465c915719106dbe234380f769c45ae3e118edb/httrack-strnlen.diff"
    sha1 "206b0c3f00a8274eb01b04fb7f11b0339423332b"
  end

  def install
    ENV.deparallelize
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
    # Don't need Gnome integration
    rm_rf Dir["#{share}/{applications,pixmaps}"]
  end
end
