require "formula"

class Lz4 < Formula
  homepage "http://code.google.com/p/lz4/"
  url "https://github.com/Cyan4973/lz4/archive/r124.tar.gz"
  sha1 "ee4943e07d08605041c86c2d2c649b375cee6c13"
  version "r124"

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
