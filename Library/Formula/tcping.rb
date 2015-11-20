class Tcping < Formula
  desc "TCP connect to the given IP/port combo"
  homepage "http://www.linuxco.de/tcping/tcping.html"
  url "http://www.linuxco.de/tcping/tcping-1.3.5.tar.gz"
  sha256 "1ad52e904094d12b225ac4a0bc75297555e931c11a1501445faa548ff5ecdbd0"

  bottle do
    cellar :any
    sha256 "1828eadf5c876317cd91a4795c88a6020e530411d519505fb3d3c8b0c1c9d77f" => :yosemite
    sha256 "3628ebf998ef807a12264cc56e0ae2b5f17034055c6789e83a2a7dc82e53a93a" => :mavericks
    sha256 "8708f8d8ed2b7e7ed62c9982fd6a6c0d420d1bb4c9ccc98db08a22ed498a1a8b" => :mountain_lion
  end

  def install
    system "make"
    bin.install "tcping"
  end

  test do
    system "#{bin}/tcping", "-q", "www.google.com", "80"
  end
end
