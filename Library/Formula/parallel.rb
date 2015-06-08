class Parallel < Formula
  desc "GNU parallel shell command"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "http://ftpmirror.gnu.org/parallel/parallel-20150122.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/parallel/parallel-20150122.tar.bz2"
  sha256 "ede876f9cb84b8dce0d8d0088fa61ccb12a6f3f61479f3720a96ee54d4bce991"

  bottle do
    cellar :any
    sha1 "5499a1bb2bffd0aaf902b18443ddaadf92251d99" => :yosemite
    sha1 "b65732571fa34ce4e3d6ffda812a52d5127b16c1" => :mavericks
    sha1 "da5b304da8d628e92ea7e008f3d1c893babcc0b4" => :mountain_lion
  end

  conflicts_with "moreutils",
    :because => "both install a 'parallel' executable. See the --without-parallel option for 'moreutils'"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
