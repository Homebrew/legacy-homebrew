require "formula"

class Wrk2 < Formula
  homepage "https://github.com/giltene/wrk2"
  head "https://github.com/giltene/wrk2.git"
  revision 1

  depends_on "openssl"

  conflicts_with "wrk-trello", :because => "both install `wrk` binaries"
  conflicts_with "wrk", :because => "both install `wrk` binaries"

  def install
    ENV.j1
    system "make"
    bin.install "wrk"
  end

  test do
    system *%W{#{bin}/wrk -c 1 -t 1 -d 1 http://example.com/}
  end
end
