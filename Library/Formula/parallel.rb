require "formula"

class Parallel < Formula
  homepage "http://savannah.gnu.org/projects/parallel/"
  url "http://ftpmirror.gnu.org/parallel/parallel-20140922.tar.bz2"
  mirror "http://ftp.gnu.org/gnu/parallel/parallel-20140922.tar.bz2"
  sha256 "4589e2c82b1ccb5be9060e010993214bb4d8ec87220be077f0c21bb5040cbd43"

  bottle do
    cellar :any
    sha1 "f0db31d409f45e4fff5f44b7599bf21364a75c1e" => :mavericks
    sha1 "191a9d0b9d6004bb4e5c0ed7a4fefd2a85c774d5" => :mountain_lion
    sha1 "70753d782bcadde6ea1b7870c06184427bd80f5e" => :lion
  end

  conflicts_with "moreutils",
    :because => "both install a 'parallel' executable. See the --without-parallel option for 'moreutils'"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
