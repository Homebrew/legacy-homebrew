require "formula"

class Dued < Formula
  homepage "https://gist.github.com/unforswearing/2263f5223e46b647f955"
  url "https://gist.githubusercontent.com/unforswearing/2263f5223e46b647f955/raw/1de9add2f295c3b7bd6c5cadb6b8346916b98558/dued.rbp"
  sha1 "4ac2474d081e575408e9ae5c8cf0c22dff326481"
  version "0.1"

  def install
    system "make"
    system "make", "install"
  end
end