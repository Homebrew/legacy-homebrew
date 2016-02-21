class Ttygif < Formula
  desc "Convert terminal recordings to animated gifs"
  homepage "https://github.com/icholy/ttygif.git"
  url "https://github.com/icholy/ttygif/archive/1.0.8.tar.gz"
  sha256 "32b3394ebaac3389c66aee225ab61846fc84b02e218d0018515a6e9345a9f114"
  head "https://github.com/icholy/ttygif.git"

  depends_on "imagemagick"
  depends_on "ttyrec"

  def install
    system "make"
    bin.install %w[ttygif concat_osx.sh]
  end
end
