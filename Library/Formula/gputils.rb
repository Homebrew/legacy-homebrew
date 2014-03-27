require 'formula'

class Gputils < Formula
  homepage 'http://gputils.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/gputils/gputils/1.2.0/gputils-1.2.0.tar.gz'
  sha1 '9f3a5d9ee7e2f4f897cd5f8ac56d6679b7c4faba'

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
