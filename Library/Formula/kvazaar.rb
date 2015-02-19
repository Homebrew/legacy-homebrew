class Kvazaar < Formula
  homepage "https://github.com/ultravideo/kvazaar"
  url "https://github.com/ultravideo/kvazaar/archive/v0.4.0.tar.gz"
  sha1 "28fce493e8fcd7274993ab46eb1a1c5d07569853"

  depends_on "yasm" => :build

  def install
    system "make", "-C", "src"
    bin.install "src/kvazaar"
  end

  test do
    assert_match "HEVC Encoder", shell_output("#{bin}/kvazaar 2>&1", 1)
  end
end
