class Nasm < Formula
  desc "Netwide Assembler (NASM) is an 80x86 assembler"
  homepage "http://www.nasm.us/"
  url "http://www.nasm.us/pub/nasm/releasebuilds/2.12.01/nasm-2.12.01.tar.xz"
  sha256 "9dbba1ce620512e435ba57e69e811fe8e07d04359e47e0a0b5e94a5dd8367489"

  bottle do
    cellar :any_skip_relocation
    sha256 "72d51c01641ae42ba73b229b3473385cacab4227922a25388f8cf1274a72b0cf" => :el_capitan
    sha256 "d710b580c309528b165b5540ffed42b59e7cc17642ffebbb7f4963b953303489" => :yosemite
    sha256 "40ce5ef6b1946c4706fb5aa14c8b5a89e65ddf60d78d5ce439369205fd096309" => :mavericks
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
