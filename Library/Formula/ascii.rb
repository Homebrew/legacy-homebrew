require 'formula'

class Ascii < Formula
  homepage 'http://www.catb.org/~esr/ascii/'
  url 'http://www.catb.org/~esr/ascii/ascii-3.14.tar.gz'
  sha1 'fd8281078c1b3d52d4080ced1855f4f540d5a501'

  def install
    system "make"
    bin.install "ascii"
    man1.install 'ascii.1'
  end

  test do
    output = `#{bin}/ascii 0x0a`
    assert output.include?("Official name: Line Feed")
    assert_equal 0, $?.exitstatus
  end
end
