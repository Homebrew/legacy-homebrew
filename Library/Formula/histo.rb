require "formula"


class Histo < Formula
  homepage "https://github.com/visionmedia/histo"
  url "https://github.com/visionmedia/histo/archive/0.0.2.tar.gz"
  sha1 "0eec89b51716cb8a91cf9088590909fdf340662c"
  head "https://github.com/visionmedia/histo.git"


  def install
    system "make"
    bin.install('histo')
  end
end
