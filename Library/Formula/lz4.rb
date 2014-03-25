require "formula"

class Lz4 < Formula
  homepage "http://code.google.com/p/lz4/"
  url "https://dl.dropboxusercontent.com/u/59565338/LZ4/lz4-r116.tar.gz"
  sha1 "ac57ea8d0604e70739869751dcb43714255b9a7d"
  version "r116"

  bottle do
    cellar :any
    sha1 "d81daa2070d46528c4fa70c4eb77ee15fe790687" => :mavericks
    sha1 "7ea1b15048bdaf49e27ae0b327c4dd501e653bde" => :mountain_lion
    sha1 "4ed51a6cf8004f234c840887d3b7e75852e2c9cf" => :lion
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    input = "testing compression and decompression"
    input_file = testpath/"in"
    input_file.write input
    output_file = testpath/"out"
    system "sh", "-c", "cat #{input_file} | lz4 | lz4 -d > #{output_file}"
    output_file.read == input
  end
end
