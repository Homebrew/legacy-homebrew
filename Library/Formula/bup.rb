require "formula"

class Bup < Formula
  homepage "https://github.com/bup/bup"
  head "https://github.com/bup/bup.git"
  url "https://github.com/bup/bup/archive/0.26.tar.gz"
  sha1 "86e636818590fe40e1074c67545bb74de6e8306b"

  option "run-tests", "Run unit tests after compilation"
  option "with-pandoc", "build and install the manpage (depends on pandoc)"

  depends_on "pandoc" => [:optional, :build]

  # Fix compilation on 10.10
  # https://github.com/bup/bup/commit/75d089e7cdb7a7eb4d69c352f56dad5ad3aa1f97
  patch do
    url "https://github.com/bup/bup/commit/75d089e7cdb7a7eb4d69c352f56dad5ad3aa1f97.diff"
    sha1 "a97d4292a7398d0bca2eb2ea0a99fb40a049c178"
  end

  def install
    system "make"
    system "make test" if build.include? "run-tests"
    system "make", "install", "DESTDIR=#{prefix}", "PREFIX="
  end
end
