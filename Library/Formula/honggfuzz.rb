class Honggfuzz < Formula
  desc     "A general-purpose, easy-to-use fuzzer with interesting analysis options."
  homepage "https://google.github.io/honggfuzz/"
  url      "https://github.com/google/honggfuzz/archive/0.6.tar.gz"
  sha256   "c95600c83b5b7836f3fdb1641565fbb07ccbf485446861c7dcb82db4172a0aa1"

  def install
    system      "make"
    bin.install "honggfuzz"
  end

  test do
    system bin/"honggfuzz", "-h"
  end
end
