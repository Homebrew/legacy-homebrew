require "formula"

class Parallel < Formula
  homepage "http://savannah.gnu.org/projects/parallel/"
  url "http://ftpmirror.gnu.org/parallel/parallel-20140622.tar.bz2"
  mirror "http://ftp.gnu.org/gnu/parallel/parallel-20140622.tar.bz2"
  sha256 "58d25784e097807617ab88f003e7c435b4686abb68b6d311e6163e5f88b9343b"

  conflicts_with "moreutils",
    :because => "both install a 'parallel' executable."

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
