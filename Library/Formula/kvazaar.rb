require "formula"

class Kvazaar < Formula
  homepage "https://github.com/ultravideo/kvazaar"
  url "https://github.com/ultravideo/kvazaar/archive/v0.3.0.tar.gz"
  sha1 "cd3924a2692d0b3ebaed7f0c88b300ea15155fb1"

  depends_on 'yasm' => :build

  def install
    system "make", "-C", "src"
    bin.install 'src/kvazaar'
  end

  test do
    system "#{bin}/kvazaar 2>&1 | grep 'HEVC Encoder v. 0.3'"
  end
end
