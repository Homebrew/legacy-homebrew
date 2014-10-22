require "formula"

class Nasm < Formula
  homepage "http://www.nasm.us/"
  url "http://www.nasm.us/pub/nasm/releasebuilds/2.11.05/nasm-2.11.05.tar.xz"
  sha256 "2f4769c2fc88dbd8df4383ce30bc86919b5d488854ab906ebcee5d5a38828a6b"

  bottle do
    cellar :any
    sha1 "d3995ba55de30d6716e21f5e428b1f4566e95de9" => :yosemite
    sha1 "09be35f0f249df74981e03663fd903ea25e6ae90" => :mavericks
    sha1 "abac9b6f33d93e2022c4ad7212b11871878f0c87" => :mountain_lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}"
    system "make install install_rdf"
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
