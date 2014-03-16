require "formula"

class Gcore < Formula
  homepage "http://osxbook.com/book/bonus/chapter8/core/"
  url "http://osxbook.com/book/bonus/chapter8/core/download/gcore-1.3.tar.gz"
  sha1 "92c0bf04577f86b05fb7bede7aa196d257f8aad2"

  def install
    ENV.universal_binary
    system "make"
    bin.install "gcore"
  end
end
