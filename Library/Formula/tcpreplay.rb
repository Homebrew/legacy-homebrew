require "formula"

class Tcpreplay < Formula
  homepage "http://tcpreplay.appneta.com"
  url "https://github.com/appneta/tcpreplay/releases/download/v4.0.5/tcpreplay-4.0.5.tar.gz"
  sha1 "878970d77e1482c9b26ac19eb2d125915a900f9b"

  bottle do
    cellar :any
    sha1 "b003d008725719da2af9bd708af9319f2ab43710" => :mavericks
    sha1 "e62ad60674fe0ceb5bfa65304c00278410bb6881" => :mountain_lion
    sha1 "9675b87cf528c950d69c8500c78ab059b601f16a" => :lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-dynamic-link"
    system "make", "install"
  end
end
