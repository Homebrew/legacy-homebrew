require "formula"

class Parallel < Formula
  homepage "http://savannah.gnu.org/projects/parallel/"
  url "http://ftpmirror.gnu.org/parallel/parallel-20140822.tar.bz2"
  mirror "http://ftp.gnu.org/gnu/parallel/parallel-20140822.tar.bz2"
  sha256 "8a146a59bc71218921d561f2c801b85e06fe3a21571083b58e6e0966dd397fd4"

  conflicts_with "moreutils",
    :because => "both install a 'parallel' executable."

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
