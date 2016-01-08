class Bgrep < Formula
  desc "Like grep but for binary strings"
  homepage "https://github.com/tmbinc/bgrep"
  url "https://github.com/tmbinc/bgrep/archive/bgrep-0.2.tar.gz"
  sha256 "24c02393fb436d7a2eb02c6042ec140f9502667500b13a59795388c1af91f9ba"
  head "https://github.com/tmbinc/bgrep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "29f0b2d7ab307eae228a03d4f42f677d9ff0884edc5c96771da36182cb592cd2" => :el_capitan
    sha256 "af4dab94130c48930d064074da8492c5531842a348747b0dd39420db738f6ae9" => :yosemite
    sha256 "b166d637dda09833c3b2c3396670347b087fef6366576303f87fb704b1d3eede" => :mavericks
  end

  def install
    system ENV.cc, ENV.cflags, "-o", "bgrep", "bgrep.c"
    bin.install "bgrep"
  end

  test do
    path = testpath/"hi.prg"
    path.binwrite [0x00, 0xc0, 0xa9, 0x48, 0x20, 0xd2, 0xff,
                   0xa9, 0x49, 0x20, 0xd2, 0xff, 0x60
                  ].pack("C*")

    assert_equal "#{path}: 00000004\n#{path}: 00000009\n",
                 shell_output("#{bin}/bgrep 20d2ff #{path}")
  end
end
