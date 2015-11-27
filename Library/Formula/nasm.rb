class Nasm < Formula
  desc "Netwide Assembler (NASM) is an 80x86 assembler"
  homepage "http://www.nasm.us/"
  revision 1

  stable do
    url "http://www.nasm.us/pub/nasm/releasebuilds/2.11.08/nasm-2.11.08.tar.xz"
    sha256 "c99467c7072211c550d147640d8a1a0aa4d636d4d8cf849f3bf4317d900a1f7f"

    # http://repo.or.cz/nasm.git/commit/4920a0324348716d6ab5106e65508496241dc7a2
    # http://bugzilla.nasm.us/show_bug.cgi?id=3392306#c5
    patch do
      url "https://raw.githubusercontent.com/Homebrew/patches/7a329c65e/nasm/nasm_outmac64.patch"
      sha256 "54bfb2a8e0941e0108efedb4a3bcdc6ce8dff0d31d3abdf2256410c0f93f5ad7"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4023e31702e37163be8c0089550b50ccb06c5de78788271f3b72c17f235d0449" => :el_capitan
    sha256 "3a3f2ead668f671710c08988ecd28d4ee778202b20fff12a4f7ffc397eda080d" => :yosemite
    sha256 "ccbea16ab6ea7f786112531697b04b0abd2709ca72f4378b7f54db83f0d7364e" => :mavericks
  end

  devel do
    url "http://www.nasm.us/pub/nasm/releasebuilds/2.11.09rc1/nasm-2.11.09rc1.tar.xz"
    sha256 "8b76b7f40701a5bdc8ef29fc352edb0714a8e921b2383072283057d2b426a890"
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}"
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
