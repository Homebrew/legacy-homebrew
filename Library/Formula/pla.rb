class Pla < Formula
  desc "A tool for building gantt charts in format PNG, EPS, PDF or SVG."
  homepage "http://www.arpalert.org/pla.html"
  url "http://www.arpalert.org/src/pla-1.1.tar.gz"
  sha256 "a213c5e1060c97618d0eb0462cfdf738532591b30f18b36a37c1a4398346ac37"

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
