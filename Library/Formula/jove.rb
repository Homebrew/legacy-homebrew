require "formula"

class Jove < Formula
  homepage "http://directory.fsf.org/wiki/Jove"
  url "ftp://ftp.cs.toronto.edu/cs/ftp/pub/hugh/jove-dev/jove4.16.0.73.tgz"
  sha1 "fca6f33465b08eed5b90e24cfb67e61bc5249dcf"

  def install
    inreplace %w{insert.c io.c io.h recover.c util.h}, "getline", "jove_getline"

    bin.mkpath
    man1.mkpath
    (lib/"jove").mkpath

    system "make", "install", "JOVEHOME=#{prefix}", "MANDIR=#{man1}"
  end

  test do
    assert_match /There's nothing to recover./, %x{#{lib}/jove/recover}
  end
end
