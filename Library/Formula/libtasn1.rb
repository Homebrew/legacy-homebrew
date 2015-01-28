class Libtasn1 < Formula
  homepage "https://www.gnu.org/software/libtasn1/"
  url "http://ftpmirror.gnu.org/libtasn1/libtasn1-4.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.2.tar.gz"
  sha1 "d2fe4bf12dbdc4d6765a04abbf8ddaf7e9163afa"

  bottle do
    cellar :any
    sha1 "8f3781a5320a3673805acf106204f3aa332a7892" => :yosemite
    sha1 "d39d835568aa45f2db736b4db2758c910babffe8" => :mavericks
    sha1 "dc5377805975c8be571a5635e8f795065e619004" => :mountain_lion
    sha1 "5cd9d101456486012c53e6aadc11ef1e987d582d" => :lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
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
