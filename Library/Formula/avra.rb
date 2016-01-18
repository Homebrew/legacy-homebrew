class Avra < Formula
  desc "Assember for the Atmel AVR microcontroller family"
  homepage "http://avra.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/avra/1.3.0/avra-1.3.0.tar.bz2"
  sha256 "a62cbf8662caf9cc4e75da6c634efce402778639202a65eb2d149002c1049712"

  bottle do
    cellar :any
    sha256 "b3063d26dedacb12dcb20cce18653227d4ba0b6b7de999748f75c8b7bb816ad3" => :yosemite
    sha256 "c991364ca6331ba74ccc59efb085040d1fb62178e4b8acb69f0fffd255733041" => :mavericks
    sha256 "256106f07e192dc8d94f1fb21c4b61e1233b3bd79b48353bb514ad42dd6e5e56" => :mountain_lion
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
    (share/"avra").install Dir["includes/*"]
  end

  test do
    (testpath/"test.asm").write " .device attiny10\n ldi r16,0x42\n"
    output = shell_output("#{bin}/avra -l test.lst test.asm")
    assert_match "Assembly complete with no errors.", output
    assert File.exist?("test.hex")
    assert_match "ldi r16,0x42", File.read("test.lst")
  end
end
