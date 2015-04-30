class Libtasn1 < Formula
  homepage "https://www.gnu.org/software/libtasn1/"
  url "http://ftpmirror.gnu.org/libtasn1/libtasn1-4.5.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.5.tar.gz"
  sha256 "89b3b5dce119273431544ecb305081f3530911001bb12e5d76588907edb71bda"

  bottle do
    cellar :any
    sha256 "c7efdc3faad00fba26b931ab3cc6d4ebdbd620c9cb484507e7932ffd55deb627" => :yosemite
    sha256 "316bd584f30c4eaae05958baf923c1998f5e94917520d8eb457492949cb01c02" => :mavericks
    sha256 "bc79f9ad98cec135b633d854bbfa01c9069733fd2c55d9d14f851ab2b7d7466c" => :mountain_lion
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
