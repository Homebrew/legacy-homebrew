class Megatools < Formula
  desc "Command-line client for Mega.co.nz"
  homepage "https://megatools.megous.com/"
  url "https://megatools.megous.com/builds/megatools-1.9.97.tar.gz"
  sha256 "3316c56ee55adef0ab113aad41ef95eb28fc15218639f69b1e04362b1c725af3"

  bottle do
    cellar :any
    sha256 "2d3149d6133aa4c0c26d5419c0944a9cec9060b3e472424802b6ec8985d437dd" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "glib-networking"
  depends_on "openssl"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Downloads a publicly hosted file and verifies its contents.
    system "#{bin}/megadl",
      "https://mega.co.nz/#!3Q5CnDCb!PivMgZPyf6aFnCxJhgFLX1h9uUTy9ehoGrEcAkGZSaI",
      "--path", "testfile.txt"
    assert_equal File.read("testfile.txt"), "Hello Homebrew!\n"
  end
end
