class Gputils < Formula
  desc "GNU PIC Utilities"
  homepage "http://gputils.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gputils/gputils/1.4.0/gputils-1.4.0-1.tar.gz"
  sha256 "d0ce93b6bcf266b8dfa0d0d589d5626a04b950a4e450ff27ef62534243ac7edb"

  bottle do
    revision 1
    sha256 "519dc4bdafc29039dfd5c12db4e58e1514554404b744119cd710f415b00e6290" => :el_capitan
    sha256 "d2ff0a1800f55f45a83003f1cbfeb4f04d9eec5ff6e029bf88799269af4aad7d" => :yosemite
    sha256 "d787ebb6410c76e5b983f977da35ee2a1ff150a49f906bd32b7422b1851383eb" => :mavericks
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
