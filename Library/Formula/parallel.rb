require "formula"

class Parallel < Formula
  homepage "http://savannah.gnu.org/projects/parallel/"
  url "http://ftpmirror.gnu.org/parallel/parallel-20141122.tar.bz2"
  mirror "http://ftp.gnu.org/gnu/parallel/parallel-20141122.tar.bz2"
  sha256 "68bcbc1e1a09b298433768f8c60c9506c13a16a96a5eebec316851d2bc22edce"

  bottle do
    cellar :any
    sha1 "2a9f8b6ab359e71f3505126c51e530439183c21f" => :yosemite
    sha1 "f60f073719078dc8e4e6279b25954ad21144d707" => :mavericks
    sha1 "12b24eb130c5a41b71fc0b8bdcca23340940d14b" => :mountain_lion
  end

  conflicts_with "moreutils",
    :because => "both install a 'parallel' executable. See the --without-parallel option for 'moreutils'"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
