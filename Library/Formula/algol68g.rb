class Algol68g < Formula
  homepage "http://www.xs4all.nl/~jmvdveer/algol.html"
  url "http://jmvdveer.home.xs4all.nl/algol68/algol68g-2.8.1.tar.gz"
  sha256 "bd499f90576a8d86008316f55e026e08abe2c9bda930e7a00cd0bec5b2b2dc44"

  depends_on "gsl" => :optional

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"hello.alg"
    path.write <<-EOS.undent
      print("Hello World")
    EOS

    assert_equal "Hello World", shell_output("#{bin}/a68g #{path}").strip
  end
end
