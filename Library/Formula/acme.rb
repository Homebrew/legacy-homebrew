class Acme < Formula
  desc "Crossassembler for multiple environments"
  homepage "https://web.archive.org/web/20150520143433/https://www.esw-heim.tu-clausthal.de/~marco/smorbrod/acme/"
  url "https://www.mirrorservice.org/sites/ftp.cs.vu.nl/pub/minix/distfiles/backup/acme096src.tar.gz"
  mirror "http://ftp.lip6.fr/pub/minix/distfiles/backup/acme096src.tar.gz"
  version "0.96"
  sha256 "31ed7f9be5cd27100b13d6c3e2faec35d15285542cbe168ec5e1b5236125decb"

  bottle do
    cellar :any
    revision 1
    sha256 "f5ed6e96c9210436569e97f2c1dff5607814fc21952db39e095c5c34ff6d9502" => :yosemite
    sha256 "990425c3d467e3ab7bb0b4ff88cf12ad7095a0bd8f22b91f86105d569e87a6a9" => :mavericks
    sha256 "1831e423ed2389b961ffd3baa9299552aa9c7553455edce8bf94bbe72de54986" => :mountain_lion
  end

  devel do
    url "https://web.archive.org/web/20150501011451/https://www.esw-heim.tu-clausthal.de/~marco/smorbrod/acme/current/acme099testing.tar.bz2"
    sha256 "cf374869265981437181609483bdb6c43f7313f81cfe57357b0ac88578038c02"
    version "0.99"
  end

  def install
    system "make", "-C", "src", "install", "BINDIR=#{bin}"
  end

  test do
    path = testpath/"a.asm"
    path.write <<-EOS
      !to "a.out", cbm
      * = $c000
      jmp $fce2
    EOS

    system bin/"acme", path
    code = File.open(testpath/"a.out", "rb") { |f| f.read.unpack("C*") }
    assert_equal [0x00, 0xc0, 0x4c, 0xe2, 0xfc], code
  end
end
