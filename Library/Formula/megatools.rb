require "formula"

class Megatools < Formula
  homepage "http://megatools.megous.com/"
  url "http://megatools.megous.com/builds/megatools-1.9.93.tar.gz"
  sha1 "06411d7ee19a3acaae97346c87ed3194d7d0c321"

  bottle do
    cellar :any
    sha1 "5eb36e9319cf36da464113512f0234ad415cba8b" => :yosemite
    sha1 "686394945133e0cb535fb92cbb4e3d98d103ddad" => :mavericks
    sha1 "a6ccf99952c6c701191ead83c6a693bf65a1d4a4" => :mountain_lion
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
