class Gputils < Formula
  desc "GNU PIC Utilities"
  homepage "http://gputils.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gputils/gputils/1.4.0/gputils-1.4.0-1.tar.gz"
  sha256 "d0ce93b6bcf266b8dfa0d0d589d5626a04b950a4e450ff27ef62534243ac7edb"

  bottle do
    sha256 "c45aa7a206c4189fcd84c5431fa085e2db597e9aa4a979fd5d66909b649e2074" => :yosemite
    sha256 "cba4bed649033815a26a588a1e6ffd14cda8c21bdbce8f60c51c65868b2509bf" => :mavericks
    sha256 "ebdd16d0f3ba5a5770aeea5b3202213704d7ef863b8898f9140e1cf949ce0534" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    # assemble with gpasm
    (testpath/"test.asm").write " movlw 0x42\n end\n"
    system "#{bin}/gpasm", "-p", "p16f84", "test.asm"
    assert File.exist?("test.hex")

    # disassemble with gpdasm
    output = shell_output("#{bin}/gpdasm -p p16f84 test.hex")
    assert_match "0000:  3042  movlw   0x42\n", output
  end
end
