require "formula"

class Parallel < Formula
  homepage "http://savannah.gnu.org/projects/parallel/"
  url "http://ftpmirror.gnu.org/parallel/parallel-20141022.tar.bz2"
  mirror "http://ftp.gnu.org/gnu/parallel/parallel-20141022.tar.bz2"
  sha256 "775779f181394353340478ebca321230a052c3e64fc04c9435d3e81697d7fab6"

  bottle do
    cellar :any
    sha1 "a0cbb83289109b948144ac8eb87f012079129c95" => :yosemite
    sha1 "95d6ec6d020555cc8981f2b0e942cf2024b820e0" => :mavericks
    sha1 "76cef437b4435627bcacfd2d88427aa8cd8c4232" => :mountain_lion
  end

  conflicts_with "moreutils",
    :because => "both install a 'parallel' executable. See the --without-parallel option for 'moreutils'"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
