require 'formula'

class Pathfinder < Formula
  homepage 'http://db.inf.uni-tuebingen.de/research/pathfinder'
  url 'http://db.inf.uni-tuebingen.de/files/research/pathfinder/download/pathfinder-0.41.tar.gz'
  sha1 '84f5581688e4c1dff27cf8e7d4354ee594f56970'

  def options
    [
      ['--enable-debug', 'enable full debbugging']
    ]
  end

  def install
    args = ["--prefix=#{prefix}"]

    if ARGV.include? '--enable-debug'
      args << '--enable-debug'
    end

    system "./configure", *args
    system "make"
    system "make install"
  end
end
