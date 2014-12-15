require "formula"

class Parallel < Formula
  homepage "http://savannah.gnu.org/projects/parallel/"
  url "http://ftpmirror.gnu.org/parallel/parallel-20141122.tar.bz2"
  mirror "http://ftp.gnu.org/gnu/parallel/parallel-20141122.tar.bz2"
  sha256 "68bcbc1e1a09b298433768f8c60c9506c13a16a96a5eebec316851d2bc22edce"

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
