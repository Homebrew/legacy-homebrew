require 'formula'

class Acme < Formula
  desc "Crossassembler for multiple environments"
  homepage 'http://www.esw-heim.tu-clausthal.de/~marco/smorbrod/acme/'
  url 'http://www.esw-heim.tu-clausthal.de/~marco/smorbrod/acme/current/acme091src.tar.gz'
  version '0.91'
  sha1 '7104ea01a2ca2962294aaac4974e10c6486534a8'

  bottle do
    cellar :any
    sha1 "1d11ae93af38d5c851bbc53bb485b7278e50447c" => :yosemite
    sha1 "84b5a3f996dab2603f7ad0c6edef309620672a0c" => :mavericks
    sha1 "86a9fb8fd72407d787032bdc98282d9af036c5d9" => :mountain_lion
  end

  devel do
    url "http://www.esw-heim.tu-clausthal.de/~marco/smorbrod/acme/current/acme093testing.tar.bz2"
    sha1 "59bde69dcbb3242fc29fc019052cbdff10dbb8f8"
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
