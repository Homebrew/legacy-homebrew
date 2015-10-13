class Libtasn1 < Formula
  desc "ASN.1 structure parser library"
  homepage "https://www.gnu.org/software/libtasn1/"
  url "http://ftpmirror.gnu.org/libtasn1/libtasn1-4.7.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.7.tar.gz"
  sha256 "a40780dc93fc6d819170240e8ece25352058a85fd1d2347ce0f143667d8f11c9"

  bottle do
    cellar :any
    sha256 "6fcbe420735451f51ca99468ce6bdfe198f8434b038735f1240d82c0f6360da7" => :el_capitan
    sha256 "9925ef918b0027184e7847cda512ed5d4dbd0aa6000f4a3cb2b80a014cb484ac" => :yosemite
    sha256 "ed3aa2c8f4dd549596bb00bc1041fc54f8926dc366476df0123b33cce3d0e85b" => :mavericks
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
