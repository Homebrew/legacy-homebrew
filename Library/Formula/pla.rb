class Pla < Formula
  homepage "http://www.arpalert.org/pla.html"
  url "http://www.arpalert.org/src/pla-0.0.tar.gz"
  sha1 "246deb5ae5b0d41abe88e82cd7940b1ea7516c44"

  depends_on "cairo"

  def install
    inreplace "Makefile", "/usr/include/cairo", "#{Formula["cairo"].include}/cairo"
    system "make"
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
