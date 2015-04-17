class Bmake < Formula
  homepage "http://www.crufty.net/help/sjg/bmake.html"
  url "http://www.crufty.net/ftp/pub/sjg/bmake-20150410.tar.gz"
  sha256 "72727f5ddce4448a0136a1e2c536f7627440e3e482700b43c666f96737b2bfce"

  bottle do
    sha256 "7d683b7293b8b9ebbda8979a715f167eb30df5c6d4162a9fd3821dbff44faf0b" => :yosemite
    sha256 "b124914d286d2c815145563702e8e0ae97ac366bf1ca4cfca05bc1e02154c203" => :mavericks
    sha256 "2588d1208a3b9e3686b2819df31229c4fa1d65202c36f83eb1e097daaf4afccd" => :mountain_lion
  end

  def install
    # The first, an oversight upstream; the second, don't pre-roff cat pages.
    inreplace "bmake.1", ".Dt MAKE", ".Dt BMAKE"
    inreplace "mk/man.mk", "MANTARGET?", "MANTARGET"

    # -DWITHOUT_PROG_LINK means "don't symlink as bmake-VERSION."
    args = [ "--prefix=#{prefix}", "-DWITHOUT_PROG_LINK", "--install" ]

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
