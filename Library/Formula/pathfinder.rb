require 'formula'

class Pathfinder < Formula
  homepage 'http://db.inf.uni-tuebingen.de/research/pathfinder'
  url 'http://db.inf.uni-tuebingen.de/files/research/pathfinder/download/pathfinder-0.41.tar.gz'
  sha1 '84f5581688e4c1dff27cf8e7d4354ee594f56970'

  option 'enable-debug', 'Enable debugging'

  def install
    args = ["--prefix=#{prefix}"]
    args << '--enable-debug' if build.include? 'enable-debug'

    system "./configure", *args
    system "make"
    system "make install"
  end
end
