class Lz4 < Formula
  desc "Lossless compression algorithm"
  homepage "https://code.google.com/p/lz4/"
  url "https://github.com/Cyan4973/lz4/archive/r130.tar.gz"
  sha256 "c48450d27524c2e5856997133e059e3cf9909241110a6e21ad278890ac425afc"
  version "r130"

  bottle do
    cellar :any
    sha1 "2d3b5ecafed3be8c54a6f87d4f2b7d5d84ebea2b" => :yosemite
    sha1 "9fb811e3c5c485c36cc4dbea9e4d8884587e0f48" => :mavericks
    sha1 "15e183eef77fd47f9fbfe94fda34a43b9f68f12b" => :mountain_lion
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    input = "testing compression and decompression"
    input_file = testpath/"in"
    input_file.write input
    output_file = testpath/"out"
    system "sh", "-c", "cat #{input_file} | #{bin}/lz4 | #{bin}/lz4 -d > #{output_file}"
    assert_equal output_file.read, input
  end
end
