class Truncate < Formula
  desc "truncates a file to a given size"
  homepage "http://www.vanheusden.com/truncate"
  url "https://github.com/flok99/truncate/archive/0.9.tar.gz"
  sha256 "a959d50cf01a67ed1038fc7814be3c9a74b26071315349bac65e02ca23891507"
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
