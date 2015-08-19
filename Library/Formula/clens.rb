class Clens < Formula
  desc "Library to help port code from OpenBSD to other operating systems"
  homepage "https://opensource.conformal.com/wiki/clens"
  url "https://github.com/conformal/clens/archive/CLENS_0_7_0.tar.gz"
  sha256 "0cc18155c2c98077cb90f07f6ad8334314606c4be0b6ffc13d6996171c7dc09d"

  patch do
    url "https://github.com/conformal/clens/commit/83648cc9027d9f76a1bc79ddddcbed1349b9d5cd.diff"
    sha256 "a685d970c9bc785dcc892f39803dad2610ce979eb58738da5d45365fd81a14be"
  end

  def install
    ENV.j1
    system "make", "all", "install", "LOCALBASE=#{prefix}"
  end
end
