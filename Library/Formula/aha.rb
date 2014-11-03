require "formula"

class Aha < Formula
  homepage "https://github.com/theZiz/aha"
  url "https://github.com/theZiz/aha/archive/0.4.7.3.tar.gz"
  sha1 "cc158029efb9dcf138fa20696f07f15ab785b035"

  def install
    system "make"
    bin.install "aha"
  end

  test do
    out = pipe_output(bin/"aha", "[35mrain[34mpill[00m")
    assert_match /color:purple;">rain.*color:blue;">pill/, out
  end
end
