require "formula"

class Parallel < Formula
  homepage "http://savannah.gnu.org/projects/parallel/"
  url "http://ftpmirror.gnu.org/parallel/parallel-20140922.tar.bz2"
  mirror "http://ftp.gnu.org/gnu/parallel/parallel-20140922.tar.bz2"
  sha256 "4589e2c82b1ccb5be9060e010993214bb4d8ec87220be077f0c21bb5040cbd43"

  bottle do
  end

  conflicts_with "moreutils",
    :because => "both install a 'parallel' executable. See the --without-parallel option for 'moreutils'"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
