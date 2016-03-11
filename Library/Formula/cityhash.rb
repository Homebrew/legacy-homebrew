class Cityhash < Formula
  desc "Hash functions for strings"
  homepage "https://github.com/google/cityhash"
  url "https://cityhash.googlecode.com/files/cityhash-1.1.1.tar.gz"
  sha256 "76a41e149f6de87156b9a9790c595ef7ad081c321f60780886b520aecb7e3db4"

  bottle do
    cellar :any
    sha256 "b09962ca43b3bb3321e1e57bf74a0936142ec5c94e198113ac3aa14e669e4d28" => :el_capitan
    sha256 "2b155183e2422811593d91b415ac2e90a00b7d6972f284e54b3214940250935e" => :yosemite
    sha256 "6c361a421b5f59c32c1098d4c29dd0c8f3048cf288c8880e954448926ed26184" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
