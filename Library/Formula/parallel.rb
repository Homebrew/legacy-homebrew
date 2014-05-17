require "formula"

class Parallel < Formula
  homepage "http://savannah.gnu.org/projects/parallel/"
  url "http://ftpmirror.gnu.org/parallel/parallel-20140422.tar.bz2"
  mirror "http://ftp.gnu.org/gnu/parallel/parallel-20140422.tar.bz2"
  sha256 "eeffac0c1b87749c500cebc975ecae57197a1202f896a2b24320e5b5171ef4dc"

  conflicts_with "moreutils",
    :because => "both install a 'parallel' executable."

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
