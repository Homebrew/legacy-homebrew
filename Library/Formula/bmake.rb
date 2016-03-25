class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "http://www.crufty.net/help/sjg/bmake.html"
  url "http://www.crufty.net/ftp/pub/sjg/bmake-20150606.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/b/bmake/bmake_20150606.orig.tar.gz"
  sha256 "c3147540fd5f64d5f2c1c7cd5d65d64d69bc5573e02707774d8eee349f043946"

  bottle do
    sha256 "25e8cf1c38ece0c9dc4f55cb65dc61812ef74ab18af60f92f5aae0fa5a0e3517" => :el_capitan
    sha256 "d902fd473759c625fff2a6303a8b2a881f6e7eee050957bed8e5715531b00569" => :yosemite
    sha256 "cc1978660d087797042a19efe067a902fad1c4081851d57f331790278868fcd9" => :mavericks
    sha256 "3ca7512237d38d75a745b23e90e8fa6c1b4e572ebea7f4d0454e4cf8f7b017bf" => :mountain_lion
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
