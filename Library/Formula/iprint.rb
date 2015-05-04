class Iprint < Formula
  homepage "https://www.samba.org/ftp/unpacked/junkcode/i.c"
  url "https://mirrors.kernel.org/debian/pool/main/i/iprint/iprint_1.3.orig.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/i/iprint/iprint_1.3.orig.tar.gz"
  sha256 "1079b2b68f4199bc286ed08abba3ee326ce3b4d346bdf77a7b9a5d5759c243a3"
  version "1.3-9"

  bottle do
    cellar :any
    sha1 "05ed7e4f7ab1ecaa578b0660140ca6b802f29beb" => :mavericks
    sha1 "93a78f64b8b51b89d9a37d94850a4347c37e343a" => :mountain_lion
    sha1 "d8b7d305d24c836ae7ffb59033bf15edc812acb3" => :lion
  end

  patch do
    url "https://mirrors.kernel.org/debian/pool/main/i/iprint/iprint_1.3-9.diff.gz"
    sha256 "3a1ff260e6d639886c005ece754c2c661c0d3ad7f1f127ddb2943c092e18ab74"
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
