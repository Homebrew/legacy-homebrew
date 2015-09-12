class Libtasn1 < Formula
  desc "ASN.1 structure parser library"
  homepage "https://www.gnu.org/software/libtasn1/"
  url "http://ftpmirror.gnu.org/libtasn1/libtasn1-4.5.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.5.tar.gz"
  sha256 "89b3b5dce119273431544ecb305081f3530911001bb12e5d76588907edb71bda"

  bottle do
    cellar :any
    sha256 "1329557b846899e36c252f441d663e4bccde1f9f4160f52d8c73b9c18499d3ae" => :el_capitan
    sha256 "71e0467545847cc6b5703125dd5ac6aa6c87146db3eb4f20b08cab8f406f68f6" => :yosemite
    sha256 "566331c00d7d067582142cc884b47f8a65ac3de2a7d1d6e7303a812d36119411" => :mavericks
    sha256 "982a2ea23e32996706eaf28b01106839a846233502ccf3053da3ded026f5d1ec" => :mountain_lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"pkix.asn").write <<-EOS.undent
      PKIX1 { }
      DEFINITIONS IMPLICIT TAGS ::=
      BEGIN
      Dss-Sig-Value ::= SEQUENCE {
           r       INTEGER,
           s       INTEGER
      }
      END
    EOS
    (testpath/"assign.asn1").write <<-EOS.undent
      dp PKIX1.Dss-Sig-Value
      r 42
      s 47
    EOS
    system "#{bin}/asn1Coding", "pkix.asn", "assign.asn1"
    assert_match /Decoding: SUCCESS/, shell_output("#{bin}/asn1Decoding pkix.asn assign.out PKIX1.Dss-Sig-Value 2>&1")
  end
end
