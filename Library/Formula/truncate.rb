class Truncate < Formula
  desc "truncates a file to a given size"
  homepage "http://www.vanheusden.com/truncate"
  url "https://github.com/flok99/truncate/archive/fc30a29dab789249f0c5f6863fdc5c8d4c9c3f69.zip"
  version "0.9"
  sha256 "f63a767555aa2edae2f340bf349465b98c636e54d211e00dd6501b702fa1837d"
  head "https://github.com/flok99/truncate.git"

  def install
    system "make"
    bin.install "truncate"
    man1.install "truncate.1"
  end

  test do
    system "#{bin}/truncate", "-s", "1k", "testfile"
  end
end
