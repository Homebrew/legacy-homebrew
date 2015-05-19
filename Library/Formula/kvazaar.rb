class Kvazaar < Formula
  desc "HEVC encoder"
  homepage "https://github.com/ultravideo/kvazaar"
  url "https://github.com/ultravideo/kvazaar/archive/v0.4.0.tar.gz"
  sha1 "28fce493e8fcd7274993ab46eb1a1c5d07569853"

  bottle do
    cellar :any
    sha1 "14925edf1ac9c07c54c872d7b5d3d7708a9f814a" => :yosemite
    sha1 "f7c026308db68e957324585b74a3ab0746289a6d" => :mavericks
    sha1 "d0c6b625b2beefbb9dafe2f9eaad678fe97d0fa7" => :mountain_lion
  end

  depends_on "yasm" => :build

  def install
    system "make", "-C", "src"
    bin.install "src/kvazaar"
  end

  test do
    assert_match "HEVC Encoder", shell_output("#{bin}/kvazaar 2>&1", 1)
  end
end
