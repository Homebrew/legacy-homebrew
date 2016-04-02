class Megatools < Formula
  desc "Command-line client for Mega.co.nz"
  homepage "https://megatools.megous.com/"
  url "https://megatools.megous.com/builds/megatools-1.9.97.tar.gz"
  sha256 "3316c56ee55adef0ab113aad41ef95eb28fc15218639f69b1e04362b1c725af3"

  bottle do
    cellar :any
    sha256 "750b9320772d15c68bc5ca3ab00ec180b5fc2321ac27115cf5bf291b9881e175" => :el_capitan
    sha256 "2003d09d3cb12e971876f3f49ae42e9e735cc9b8e2d830181d1d5c12a326f960" => :yosemite
    sha256 "c4b57807031a24903a8d8a103c5d7d964deb21b2065a100a8c1b90efbb633ff8" => :mavericks
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
