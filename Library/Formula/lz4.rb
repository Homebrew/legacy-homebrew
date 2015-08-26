class Lz4 < Formula
  desc "Lossless compression algorithm"
  homepage "http://www.lz4.info/"
  url "https://github.com/Cyan4973/lz4/archive/r131.tar.gz"
  version "r131"
  sha256 "9d4d00614d6b9dec3114b33d1224b6262b99ace24434c53487a0c8fd0b18cfed"
  head "https://github.com/Cyan4973/lz4.git"

  bottle do
    cellar :any
    sha256 "246808b1662baa862812fb15923f997e40329bcb0c0ebd4595af5eb90d9c5ff9" => :yosemite
    sha256 "c38d6b8d0d0c65580e422b3baa3f19cb051e9c02f05ee02ea1fbb5721959a764" => :mavericks
    sha256 "549d8bdae519e3315ecfab95ffd3a657d6991f72571c9720dc7d976d7445bd24" => :mountain_lion
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
