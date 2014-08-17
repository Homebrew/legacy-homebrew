require "formula"

class Bup < Formula
  homepage "https://github.com/bup/bup"
  head "https://github.com/bup/bup.git", :branch => "master"
  url "https://github.com/bup/bup/archive/0.26.tar.gz"
  sha1 "86e636818590fe40e1074c67545bb74de6e8306b"

  option "run-tests", "Run unit tests after compilation"

  def install
    system "make"
    system "make test" if build.include? "run-tests"
    system "make", "install", "DESTDIR=#{prefix}", "PREFIX="
  end
end
