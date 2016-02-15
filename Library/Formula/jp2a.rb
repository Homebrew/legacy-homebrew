class Jp2a < Formula
  desc "Convert JPG images to ASCII"
  homepage "http://csl.sublevel3.org/jp2a/"
  url "https://downloads.sourceforge.net/project/jp2a/jp2a/1.0.6/jp2a-1.0.6.tar.gz"
  sha256 "0930ac8a9545c8a8a65dd30ff80b1ae0d3b603f2ef83b04226da0475c7ccce1c"

  bottle do
    cellar :any
    sha256 "1a16fd055a4c68ef949df2f37f690259860d0c3d97962fc1b0bc5b8654f1b442" => :yosemite
    sha256 "b31b7564584f3e91dc73c4f511d74c26341d621a5b6e0533541237400acfca84" => :mavericks
    sha256 "d2f2828c5ed021cac439243a6c5fbb29b9ec460fc96d7fa19c69bec7838d4689" => :mountain_lion
  end

  option "without-test", "Skip compile-time tests"

  deprecated_option "without-check" => "without-test"

  depends_on "jpeg"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "test" if build.with? "test"
    system "make", "install"
  end

  test do
    # the test fails if this is not set
    ENV["TERM"] = "xterm-256color"
    system "#{bin}/jp2a", test_fixtures("test.jpg")
  end
end
