class Parallel < Formula
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "http://ftpmirror.gnu.org/parallel/parallel-20150122.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/parallel/parallel-20150122.tar.bz2"
  sha256 "ede876f9cb84b8dce0d8d0088fa61ccb12a6f3f61479f3720a96ee54d4bce991"

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
    system "make", "install"
  end
end
