class Iprint < Formula
  desc "Provides a print_one function"
  homepage "https://www.samba.org/ftp/unpacked/junkcode/i.c"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/i/iprint/iprint_1.3.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/i/iprint/iprint_1.3.orig.tar.gz"
  version "1.3-9"
  sha256 "1079b2b68f4199bc286ed08abba3ee326ce3b4d346bdf77a7b9a5d5759c243a3"

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "caa018741bb84409295f4fec33bcf427df199e717abf1323c9325d44238548ff" => :el_capitan
    sha256 "eb0a1df1375a29fd3a88cddbe844820c9650b4ee14406245ee5d93ad41e48586" => :yosemite
    sha256 "dfc0ad66122de0187db789cdafde75a367dc02748eede381567ca8f8a9208bde" => :mavericks
  end

  patch do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/i/iprint/iprint_1.3-9.diff.gz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/i/iprint/iprint_1.3-9.diff.gz"
    sha256 "3a1ff260e6d639886c005ece754c2c661c0d3ad7f1f127ddb2943c092e18ab74"
  end

  def install
    system "make"
    bin.install "i"
    man1.install "i.1"
  end

  test do
    assert_equal shell_output("#{bin}/i 1234"), "1234 0x4D2 02322 0b10011010010\n"
  end
end
