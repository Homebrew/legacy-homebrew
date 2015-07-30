class Acme < Formula
  desc "Crossassembler for multiple environments"
  homepage "https://web.archive.org/web/20150520143433/https://www.esw-heim.tu-clausthal.de/~marco/smorbrod/acme/"
  url "https://www.mirrorservice.org/sites/ftp.cs.vu.nl/pub/minix/distfiles/backup/acme091src.tar.gz"
  mirror "http://ftp.lip6.fr/pub/minix/distfiles/backup/acme091src.tar.gz"
  version "0.91"
  sha256 "31ed7f9be5cd27100b13d6c3e2faec35d15285542cbe168ec5e1b5236125decb"

  bottle do
    cellar :any
    sha1 "1d11ae93af38d5c851bbc53bb485b7278e50447c" => :yosemite
    sha1 "84b5a3f996dab2603f7ad0c6edef309620672a0c" => :mavericks
    sha1 "86a9fb8fd72407d787032bdc98282d9af036c5d9" => :mountain_lion
  end

  devel do
    url "https://web.archive.org/web/20150501011451/https://www.esw-heim.tu-clausthal.de/~marco/smorbrod/acme/current/acme093testing.tar.bz2"
    sha256 "cf374869265981437181609483bdb6c43f7313f81cfe57357b0ac88578038c02"
    version "0.93"
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
