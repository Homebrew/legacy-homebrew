class Fcrackzip < Formula
  homepage "http://oldhome.schmorp.de/marc/fcrackzip.html"
  url "http://oldhome.schmorp.de/marc/data/fcrackzip-1.0.tar.gz"
  sha256 "4a58c8cb98177514ba17ee30d28d4927918bf0bdc3c94d260adfee44d2d43850"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"secret").write "homebrew"
    system "zip", "-qe", "-P", "a", "secret.zip", "secret"
    assert_equal "PASSWORD FOUND!!!!: pw == a",
                 shell_output("#{bin}/fcrackzip -u -l 1 secret.zip").strip
  end
end
