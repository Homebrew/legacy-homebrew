class Lz4 < Formula
  homepage "https://code.google.com/p/lz4/"
  url "https://github.com/Cyan4973/lz4/archive/r127.tar.gz"
  sha1 "1aa7d4bb62eb79f88b33f86f9890dc9f96797af5"
  version "r127"

  bottle do
    cellar :any
    sha1 "41c29b21cde036ed9a2d6d7f2461fb8ec4b78ba5" => :yosemite
    sha1 "9d158cf88ad8752ae91114323725267e0995a45b" => :mavericks
    sha1 "abe1e9d6210f597235b864a6ee1225ddc1adcf76" => :mountain_lion
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
