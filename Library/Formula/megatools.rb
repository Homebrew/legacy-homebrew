class Megatools < Formula
  desc "Command-line client for Mega.co.nz"
  homepage "https://megatools.megous.com/"
  url "https://megatools.megous.com/builds/megatools-1.9.96.tar.gz"
  sha256 "c657a0988223aada021a7a6ed408227fc66435de7248f23952ad7adf9e1242f0"

  bottle do
    cellar :any
    sha256 "2e6e2bfa2b126d77b19bcf6338b3081f2ec0bef5d7eefbd5e258dcf077c70591" => :el_capitan
    sha256 "63735bfe9e6c5a3a29e9b2902d4cf8f954383a3d0091b94cec03b4c47e023df1" => :yosemite
    sha256 "2025daddcac02c741c6cd60d89e91787fde3ab54955bdebc34961edc349b2c90" => :mavericks
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
