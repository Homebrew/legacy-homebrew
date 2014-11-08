require "formula"

class Asn1c < Formula
  homepage "http://lionet.info/asn1c/blog/"
  url "http://lionet.info/soft/asn1c-0.9.26.tar.gz"
  sha1 "9b1d86b91d37884419f9f062ecd787e293c48637"

  def install
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
