require 'formula'

class Pathfinder < Formula
  homepage 'http://db.inf.uni-tuebingen.de/research/pathfinder'
  url 'http://db.inf.uni-tuebingen.de/files/research/pathfinder/download/pathfinder-0.41.tar.gz'
  md5 '3cfd1739778cc2156ebe107544672b83'

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
