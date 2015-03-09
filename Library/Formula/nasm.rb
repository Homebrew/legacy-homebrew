require "formula"

class Nasm < Formula
  homepage "http://www.nasm.us/"
  url "http://www.nasm.us/pub/nasm/releasebuilds/2.11.08/nasm-2.11.08.tar.xz"
  sha256 "c99467c7072211c550d147640d8a1a0aa4d636d4d8cf849f3bf4317d900a1f7f"

  bottle do
    cellar :any
    sha1 "c90a113cf8671959b89334c2e36a7b8670533a96" => :yosemite
    sha1 "488ec9f2966ec5cc88b453053522cc1ddaaf0b54" => :mavericks
    sha1 "1a38b898039459c2ecd8374fe984c94bb0305adf" => :mountain_lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}"
    system "make install install_rdf"
  end

  test do
    (testpath/"foo.s").write <<-EOS
      mov eax, 0
      mov ebx, 0
      int 0x80
    EOS

    system "#{bin}/nasm", "foo.s"
    code = File.open("foo", "rb") { |f| f.read.unpack("C*") }
    expected = [0x66, 0xb8, 0x00, 0x00, 0x00, 0x00, 0x66, 0xbb,
                0x00, 0x00, 0x00, 0x00, 0xcd, 0x80]
    assert_equal expected, code
  end
end
