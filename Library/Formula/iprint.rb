require "formula"

class Iprint < Formula

  homepage "http://www.samba.org/ftp/unpacked/junkcode/i.c"
  url "http://ftp.debian.org/debian/pool/main/i/iprint/iprint_1.3.orig.tar.gz"
  sha1 "1b423107cf6b1e5c2257648047ff91f5c6ac2249"
  version "1.3-9"

  patch do
    url "http://ftp.debian.org/debian/pool/main/i/iprint/iprint_1.3-9.diff.gz"
    sha1 "6164e8e9bd0e08542de34bbf386cd1f0193f17c5"
  end

  def install
    system "make"
    bin.install "i"
    man1.mkpath
    man1.install "i.1"
  end

  test do
    assert_equal shell_output("#{bin}/i 1234"), "1234 0x4D2 02322 0b10011010010\n"
  end

end
