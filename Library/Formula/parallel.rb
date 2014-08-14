require "formula"

class Parallel < Formula
  homepage "http://savannah.gnu.org/projects/parallel/"
  url "http://ftpmirror.gnu.org/parallel/parallel-20140722.tar.bz2"
  mirror "http://ftp.gnu.org/gnu/parallel/parallel-20140722.tar.bz2"
  sha256 "b6e0b8be4f15ea9f451b6a742e914aaa234a9008946aae151aff107a2172bb98"

  conflicts_with "moreutils",
    :because => "both install a 'parallel' executable."

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
