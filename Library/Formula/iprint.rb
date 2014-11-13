require "formula"

class Iprint < Formula

  homepage "http://www.samba.org/ftp/unpacked/junkcode/i.c"
  url "http://ftp.debian.org/debian/pool/main/i/iprint/iprint_1.3.orig.tar.gz"
  sha1 "1b423107cf6b1e5c2257648047ff91f5c6ac2249"
  version "1.3-9"

  bottle do
    cellar :any
    sha1 "05ed7e4f7ab1ecaa578b0660140ca6b802f29beb" => :mavericks
    sha1 "93a78f64b8b51b89d9a37d94850a4347c37e343a" => :mountain_lion
    sha1 "d8b7d305d24c836ae7ffb59033bf15edc812acb3" => :lion
  end

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
