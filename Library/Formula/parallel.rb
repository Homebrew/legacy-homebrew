require "formula"

class Parallel < Formula
  homepage "http://savannah.gnu.org/projects/parallel/"
  url "http://ftpmirror.gnu.org/parallel/parallel-20141022.tar.bz2"
  mirror "http://ftp.gnu.org/gnu/parallel/parallel-20141022.tar.bz2"
  sha256 "775779f181394353340478ebca321230a052c3e64fc04c9435d3e81697d7fab6"

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
