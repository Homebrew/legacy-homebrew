require 'formula'

class Avra < Formula
  homepage 'http://avra.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/avra/1.3.0/avra-1.3.0.tar.bz2'
  sha1 '7ad7d168b02107d4f2d72951155798c2fd87d5a9'

  depends_on :autoconf
  depends_on :automake

  def install
    # build fails if these don't exist
    touch 'NEWS'
    touch 'ChangeLog'
    cd "src" do
      system "./bootstrap"
      system "./configure", "--prefix=#{prefix}"
      system "make install"
    end
  end

  test do
    (testpath/"test.asm").write " .device attiny10\n ldi r16,0x42\n"
    output = shell_output("#{bin}/avra -l test.lst test.asm")
    assert output.include?("Assembly complete with no errors.")
    assert File.exist?("test.hex")
    assert File.read("test.lst").include?("ldi r16,0x42")
  end
end
