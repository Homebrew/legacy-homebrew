require "formula"

class Lz4 < Formula
  homepage "http://code.google.com/p/lz4/"
  url "https://dl.dropboxusercontent.com/u/59565338/LZ4/lz4-r116.tar.gz"
  sha1 "ac57ea8d0604e70739869751dcb43714255b9a7d"
  version "r116"

  bottle do
    cellar :any
    sha1 "64ed763d71baa31fff5d20ea815ddad4e727ef35" => :mavericks
    sha1 "abd873485e052034929edef016b274e52947655f" => :mountain_lion
    sha1 "5130288a257b8df4da7538789a38ab53f3bd9a58" => :lion
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
