class Iprint < Formula
  desc "Provides a print_one function"
  homepage "https://www.samba.org/ftp/unpacked/junkcode/i.c"
  url "https://mirrors.kernel.org/debian/pool/main/i/iprint/iprint_1.3.orig.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/i/iprint/iprint_1.3.orig.tar.gz"
  sha256 "1079b2b68f4199bc286ed08abba3ee326ce3b4d346bdf77a7b9a5d5759c243a3"
  version "1.3-9"

  bottle do
    cellar :any
    revision 1
    sha256 "0a0a7718cacd77588b21935d4e0fa9049ea8d893aa9938710cbe37050fed8516" => :yosemite
    sha256 "ec79a0435262729459e0241957c365107d29b4420ddfd930bbc1d28e28da4a0a" => :mavericks
    sha256 "2568a346cd14a68e86533522e358b106f620d29d1730b5c8b38d3a920cd33eed" => :mountain_lion
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
