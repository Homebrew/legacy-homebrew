class Speedread < Formula
  desc "Simple terminal-based rapid serial visual presentation (RSVP) reader"
  homepage "https://github.com/pasky/speedread"
  url "https://github.com/pasky/speedread/archive/v1.0.tar.gz"
  sha256 "a65f5bec427e66893663bcfc49a22e43169dd35976302eaed467eec2a5aafc1b"

  head "https://github.com/pasky/speedread.git"

  bottle :unneeded

  def install
    bin.install "speedread"
  end

  test do
    system "#{bin}/speedread", "-w 1000", "<(echo This is a test)"
  end
end
