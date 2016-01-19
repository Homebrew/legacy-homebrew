class Httrack < Formula
  desc "Website copier/offline browser"
  homepage "https://www.httrack.com/"
  # Always use mirror.httrack.com when you link to a new version of HTTrack, as
  # link to download.httrack.com will break on next HTTrack update.
  url "https://mirror.httrack.com/historical/httrack-3.48.21.tar.gz"
  sha256 "871b60a1e22d7ac217e4e14ad4d562fbad5df7c370e845f1ecf5c0e4917be482"

  bottle do
    revision 1
    sha256 "032f5fde39f04bdf772c223cdcd4974a7bb72bfcff0f71f34a8716870a80e37c" => :el_capitan
    sha256 "5dafcc2d3cf49fcbf3b804aacd42955d32cfff7643fdbb157ffbecbdaddfae68" => :yosemite
    sha256 "d6c9e71315a64a0fb1ac42e3515742f6d7b8dfac6ec1049a0f81e5aedd4f4364" => :mavericks
  end

  depends_on "openssl"

  def install
    ENV.deparallelize
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
    # Don't need Gnome integration
    rm_rf Dir["#{share}/{applications,pixmaps}"]
  end

  test do
    download = "https://raw.githubusercontent.com/Homebrew/homebrew/65c59dedea31/.yardopts"
    system bin/"httrack", download, "-O", testpath
    assert File.exist?("raw.githubusercontent.com")
  end
end
