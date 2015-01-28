require "formula"

class Megatools < Formula
  homepage "http://megatools.megous.com/"
  url "http://megatools.megous.com/builds/megatools-1.9.94.tar.gz"
  sha1 "d9d664047496c38495cd7196c481164eaa1d51e0"

  bottle do
    cellar :any
    sha1 "164906449d8130713bd1fe8852871cada91cd280" => :yosemite
    sha1 "cf1c682531f8e0fa59d4d3490fded31eed08df61" => :mavericks
    sha1 "e025e14f30ad6f2a7dd13e116f1d3c55fffcef9b" => :mountain_lion
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
