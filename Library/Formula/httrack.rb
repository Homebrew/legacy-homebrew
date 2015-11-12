class Httrack < Formula
  desc "Website copier/offline browser"
  homepage "https://www.httrack.com/"
  # Always use mirror.httrack.com when you link to a new version of HTTrack, as
  # link to download.httrack.com will break on next HTTrack update.
  url "https://mirror.httrack.com/historical/httrack-3.48.21.tar.gz"
  sha256 "871b60a1e22d7ac217e4e14ad4d562fbad5df7c370e845f1ecf5c0e4917be482"

  bottle do
    sha256 "b1087aa6b2d33562c4e230b3d55bbd4a525fd2bb5fd1f2b0d2d3bcc12a6eb534" => :el_capitan
    sha256 "f74a06fd065898048d3e27aebdf11e5d9bb186586e82264250bcf06a6f6ec37b" => :yosemite
    sha256 "e309068ddd030d866028c6c383d2093fd2a6a62f00817853876f339fb69cc10c" => :mavericks
    sha256 "2097533c4e53afdc801075cef34c5a15819e51c4e0de4f9717bb958d9eace283" => :mountain_lion
  end

  depends_on "openssl"

  def install
    ENV.deparallelize
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
    # Don't need Gnome integration
    rm_rf Dir["#{share}/{applications,pixmaps}"]
  end
end
