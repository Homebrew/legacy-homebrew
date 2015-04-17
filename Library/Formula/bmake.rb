class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "http://www.crufty.net/help/sjg/bmake.html"
  url "http://www.crufty.net/ftp/pub/sjg/bmake-20150606.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/b/bmake/bmake_20150606.orig.tar.gz"
  sha256 "c3147540fd5f64d5f2c1c7cd5d65d64d69bc5573e02707774d8eee349f043946"

  bottle do
    sha256 "d04c6d1053a37523def6b64436b892740234ccb2478d35ddb389cf9fcba78cbb" => :yosemite
    sha256 "f953d4ff22e6ecbad0a33ea3b37becf5be6b5a8bbbb69a6c4d0f0ad69f61f534" => :mavericks
    sha256 "c5dc94d4a158a3b3517663ac77e670b5154a69b81c3ebb9d425cee4b81171c45" => :mountain_lion
  end

  def install
    # The first, an oversight upstream; the second, don't pre-roff cat pages.
    inreplace "bmake.1", ".Dt MAKE", ".Dt BMAKE"
    inreplace "mk/man.mk", "MANTARGET?", "MANTARGET"

    # -DWITHOUT_PROG_LINK means "don't symlink as bmake-VERSION."
    args = ["--prefix=#{prefix}", "-DWITHOUT_PROG_LINK", "--install"]

    system "sh", "boot-strap", *args

    man1.install "bmake.1"
  end

  test do
    (testpath/"Makefile").write <<-EOS.undent
      all: hello

      hello:
      \t@echo 'Test successful.'

      clean:
      \trm -rf Makefile
    EOS
    system bin/"bmake"
    system bin/"bmake", "clean"
  end
end
