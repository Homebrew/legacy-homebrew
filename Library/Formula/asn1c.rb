class Asn1c < Formula
  desc "Compile ASN.1 specifications into C source code"
  homepage "http://lionet.info/asn1c/blog/"
  url "https://github.com/vlm/asn1c/releases/download/v0.9.27/asn1c-0.9.27.tar.gz"
  mirror "http://lionet.info/soft/asn1c-0.9.27.tar.gz"
  sha256 "025f64e1c27211b36e181350b52fde34ad23f4330fff96b2563ed3fda7b0db9e"

  bottle do
    sha256 "c5fe1a7eafbd35d91566118f3e0f29ac27e5f8dd769f038bc34fa2eb4873723a" => :el_capitan
    sha256 "d3ea138d06691c9aa0589efb8d55bb908d79b65d3b6775e02f21cbabddee284c" => :yosemite
    sha256 "8be35afe4531688fb5bfbe4212e989151c75523882404cb0f4362c0c558ba033" => :mavericks
    sha256 "ea5675912a725aeef51f51c6a0754f174a1254aeaa581ffa491cc2c50df71310" => :mountain_lion
  end

  head do
    url "https://github.com/vlm/asn1c.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "-iv" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test.asn1").write <<-EOS.undent
      MyModule DEFINITIONS ::=
      BEGIN

      MyTypes ::= SEQUENCE {
         myObjectId    OBJECT IDENTIFIER,
         mySeqOf       SEQUENCE OF MyInt,
         myBitString   BIT STRING {
                              muxToken(0),
                              modemToken(1)
                     }
      }

      MyInt ::= INTEGER (0..65535)

      END
    EOS

    system "#{bin}/asn1c", "test.asn1"
  end
end
