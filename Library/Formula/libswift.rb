require "formula"

class Libswift < Formula
  homepage "http://libswift.org/"
  url "https://github.com/libswift/libswift/archive/daddd52aade71e692aedd498d8fc4ea1c633d840.tar.gz"
  sha1 "20619602d7d7b6c30b36cefa41d1939b6fd4db18"
  version "10"
  head 'https://github.com/libswift/libswift.git', :branch => :devel

  depends_on 'libevent'

  def install
    system "make"
    bin.install "swift"
  end

  test do
    # make a merkle tree hash from an arbitrary file
    system "#{bin}/swift -f #{bin}/swift"
  end
end
