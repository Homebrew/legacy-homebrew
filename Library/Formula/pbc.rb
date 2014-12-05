require "formula"

class Pbc < Formula
  homepage "http://crypto.stanford.edu/pbc/"
  url "http://crypto.stanford.edu/pbc/files/pbc-0.5.14.tar.gz"
  sha1 "8947f1a5a32d5c2d1f5113ccbb1e0d25ca5ce1c9"
  head "http://repo.or.cz/r/pbc.git"

  depends_on "gmp"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
