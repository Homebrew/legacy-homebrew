class Ttygif < Formula

  homepage "https://github.com/icholy/ttygif.git"
  head "https://github.com/icholy/ttygif.git", :branch => "master"
  url "https://github.com/icholy/ttygif/archive/1.0.8.tar.gz"
  sha256 "32b3394ebaac3389c66aee225ab61846fc84b02e218d0018515a6e9345a9f114"

  depends_on "imagemagick"
  depends_on "ttyrec"

  def install
    system "make"
    bin.install("ttygif")
    bin.install("concat_osx.sh")
  end
end
