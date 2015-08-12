class Avra < Formula
  desc "Assember for the Atmel AVR microcontroller family"
  homepage "http://avra.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/avra/1.3.0/avra-1.3.0.tar.bz2"
  sha256 "a62cbf8662caf9cc4e75da6c634efce402778639202a65eb2d149002c1049712"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "2269beb5581fec707e544f281ae7e5b21250fd0975ee10daed45212aabb31413" => :el_capitan
    sha256 "8a382baf62c225aef1730ff1c53dd81257cea6da6c43f227b3405b673968e363" => :yosemite
    sha256 "2e208cec5f270c91c9afc0349236a9abb0622e1e8208c67d25c90f017fcecf65" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    # build fails if these don't exist
    touch "NEWS"
    touch "ChangeLog"
    cd "src" do
      system "./bootstrap"
      system "./configure", "--prefix=#{prefix}"
      system "make", "install"
    end
    pkgshare.install Dir["includes/*"]
  end

  test do
    (testpath/"test.asm").write " .device attiny10\n ldi r16,0x42\n"
    output = shell_output("#{bin}/avra -l test.lst test.asm")
    assert_match "Assembly complete with no errors.", output
    assert File.exist?("test.hex")
    assert_match "ldi r16,0x42", File.read("test.lst")
  end
end
