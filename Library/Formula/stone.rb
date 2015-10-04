class Stone < Formula
  desc "TCP/IP packet repeater in the application layer"
  homepage "http://www.gcd.org/sengoku/stone/"
  url "http://www.gcd.org/sengoku/stone/stone-2.3e.tar.gz"
  sha256 "b2b664ee6771847672e078e7870e56b886be70d9ff3d7b20d0b3d26ee950c670"

  option "with-ssl", "SSL support"

  def install
    target = (build.with? "ssl") ? "macosx-ssl" : "macosx"
    system "make", target
    bin.install "stone"
  end
end
