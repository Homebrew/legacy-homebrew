require "formula"

class Gputils < Formula
  homepage "http://gputils.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gputils/gputils/1.3.0/gputils-1.3.0.tar.gz"
  sha1 "5e4c86174a33af17de5079cdc689ff045e9407a7"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end

  test do
    # assemble with gpasm
    (testpath/"test.asm").write " movlw 0x42\n end\n"
    system "#{bin}/gpasm -p p16f84 test.asm"
    assert File.exist?("test.hex")

    # disassemble with gpdasm
    output = `#{bin}/gpdasm -p p16f84 test.hex`
    assert_equal "000000:  3042  movlw\t0x42\n", output
    assert_equal 0, $?.exitstatus
  end
end
