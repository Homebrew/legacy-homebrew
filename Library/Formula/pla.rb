class Pla < Formula
  desc "A tool for building gantt charts in format PNG, EPS, PDF or SVG."
  homepage "http://www.arpalert.org/pla.html"
  url "http://www.arpalert.org/src/pla-1.1.tar.gz"
  sha256 "a213c5e1060c97618d0eb0462cfdf738532591b30f18b36a37c1a4398346ac37"

  bottle do
    cellar :any
    sha256 "03a5a838c567433c41306ca1b8f1464612647c5348aa82475f2cb4e153701404" => :yosemite
    sha256 "57cd25f3878fd390b1387883632f6d2368337a189c8cf1481d74141716b646f1" => :mavericks
    sha256 "956bf4efa39b1ef9e29c17be02e444dfdf2bac81ba73235a8be72904427989c9" => :mountain_lion
  end

  depends_on "cairo"

  def install
    ENV.prepend "CFLAGS", "-I#{Formula["cairo"].opt_include}/cairo"
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "pla"
  end

  test do
    (testpath/"test.pla").write <<-EOS.undent
    [4] REF0 Install des serveurs
      color #8cb6ce
      child 1
      child 2
      child 3

      [1] REF0 Install 1
        start 2010-04-08 01
        duration 24
        color #8cb6ce
        dep 2
        dep 6
        EOS
    system "#{bin}/pla", "-i", "#{testpath}/test.pla", "-o test"
  end
end
