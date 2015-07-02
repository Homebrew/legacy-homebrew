class Libdistance < Formula
  homepage "http://monkey.org/~jose/software/libdistance/"
  desc "The distance library is used to compare pieces of data for similarity. Specifically, it contains a number of methods to find the \"edit distance\" between inputs, or the number of differences between them. These differences are calculated using various mechanisms. The inputs to these functions can be character strings or arbitrary data."
  url "http://monkey.org/~jose/software/libdistance/libdistance-0.2.2.tar.gz"
  sha256 "65364e07c9fe78ef34fc0e563aff2317ab0aba7549da07adea929426a708e6ad"

  def install
    system "make"
    system "make", "-C", "test"

    include.install "distance.h"
    lib.install "libdistance.a"

    mkdir "#{prefix}/test"
    cp "test/test", "#{prefix}/test/"
  end

  test do
    system "#{prefix}/test/test"
  end
end
