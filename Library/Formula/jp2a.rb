class Jp2a < Formula
  desc "Convert JPG images to ASCII"
  homepage "http://csl.sublevel3.org/jp2a/"
  url "https://downloads.sourceforge.net/project/jp2a/jp2a/1.0.6/jp2a-1.0.6.tar.gz"
  sha256 "0930ac8a9545c8a8a65dd30ff80b1ae0d3b603f2ef83b04226da0475c7ccce1c"

  bottle do
    cellar :any
    sha1 "f6c1ccaac73b7a9e6c570a97f0285c2191b70aea" => :yosemite
    sha1 "5b9d74b016ee09b1f4e72079c34c2f0612927aeb" => :mavericks
    sha1 "2cad22009e62e20931d65d1b1661de5cad980bb2" => :mountain_lion
  end

  option "without-check", "Skip compile-time tests."

  depends_on "jpeg"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "test" if build.with? "check"
    system "make", "install"
  end

  test do
    # the test fails if this is not set
    ENV["TERM"] = "xterm-256color"
    system "#{bin}/jp2a", test_fixtures("test.jpg")
  end
end
