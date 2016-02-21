class Ttygif < Formula

  homepage "https://github.com/icholy/ttygif.git"
  head "https://github.com/icholy/ttygif.git", :branch => "master"
  url "https://github.com/icholy/ttygif/archive/1.0.8.zip"
  sha1 "00e76af8ac11d8522ff32d5c86cba07545bf54c6"

  depends_on "imagemagick"
  depends_on "ttyrec"

  def install
    system "make"
    bin.install("ttygif")
    bin.install("concat_osx.sh")
  end
end
