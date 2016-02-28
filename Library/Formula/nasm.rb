class Nasm < Formula
  desc "Netwide Assembler (NASM) is an 80x86 assembler"
  homepage "http://www.nasm.us/"
  url "http://www.nasm.us/pub/nasm/releasebuilds/2.12/nasm-2.12.tar.xz"
  sha256 "f34cc1e984ed619b8f9e96cea632e3c6fdea5e039069dbcb63397b7bd004f5a8"

  bottle do
    cellar :any_skip_relocation
    sha256 "4023e31702e37163be8c0089550b50ccb06c5de78788271f3b72c17f235d0449" => :el_capitan
    sha256 "3a3f2ead668f671710c08988ecd28d4ee778202b20fff12a4f7ffc397eda080d" => :yosemite
    sha256 "ccbea16ab6ea7f786112531697b04b0abd2709ca72f4378b7f54db83f0d7364e" => :mavericks
  end

  head do
    url "git://repo.or.cz/nasm.git"
    depends_on "autoconf" => :build
    depends_on "asciidoc" => :build
    depends_on "xmlto" => :build
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "manpages" if build.head?
    system "make", "install", "install_rdf"
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
