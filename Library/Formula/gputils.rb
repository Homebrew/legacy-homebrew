class Gputils < Formula
  desc "GNU PIC Utilities"
  homepage "http://gputils.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gputils/gputils/1.4.0/gputils-1.4.0-1.tar.gz"
  sha256 "d0ce93b6bcf266b8dfa0d0d589d5626a04b950a4e450ff27ef62534243ac7edb"

  bottle do
    sha1 "8990a94d132cc92b08518767ecaa25c93246f7cb" => :yosemite
    sha1 "2536c92c27e1982743965fa4c5c3bbae997105e1" => :mavericks
    sha1 "b4ef0c6743be8f8b0cd11e7148cee046f8780d59" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    # assemble with gpasm
    (testpath/"test.asm").write " movlw 0x42\n end\n"
    system "#{bin}/gpasm -p p16f84 test.asm"
    assert File.exist?("test.hex")

    # disassemble with gpdasm
    output = `#{bin}/gpdasm -p p16f84 test.hex`
    assert_equal "0000:  3042  movlw   0x42\n", output
    assert_equal 0, $?.exitstatus
  end
end
