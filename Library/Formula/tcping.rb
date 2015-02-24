class Tcping < Formula
  homepage "http://www.linuxco.de/tcping/tcping.html"
  url "http://www.linuxco.de/tcping/tcping-1.3.5.tar.gz"
  sha1 "ecc5fe7fb2f8e86a1fc2d09651310b26fa922c7b"

  bottle do
    cellar :any
    sha1 "d0a50ca49925897916c3ab8e06b0a2c3aa6cb48b" => :yosemite
    sha1 "38d8390423e2fc6c4005589f7fa7eff28d065372" => :mavericks
    sha1 "539939ac73c05e53d4304f17c5f91fdc078dec7d" => :mountain_lion
  end

  def install
    system "make"
    bin.install "tcping"
  end

  test do
    system "#{bin}/tcping", "www.google.com", "80"
  end
end
