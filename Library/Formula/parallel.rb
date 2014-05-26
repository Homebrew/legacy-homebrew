require "formula"

class Parallel < Formula
  homepage "http://savannah.gnu.org/projects/parallel/"
  url "http://ftpmirror.gnu.org/parallel/parallel-20140522.tar.bz2"
  mirror "http://ftp.gnu.org/gnu/parallel/parallel-20140522.tar.bz2"
  sha256 "4a4674738527da2c2f0710d9fd4bf79876559b175dfdd3279805065be538a457"

  conflicts_with "moreutils",
    :because => "both install a 'parallel' executable."

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
