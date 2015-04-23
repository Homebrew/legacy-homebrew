class Bmake < Formula
  homepage "http://www.crufty.net/help/sjg/bmake.html"
  url "http://www.crufty.net/ftp/pub/sjg/bmake-20150411.tar.gz"
  sha256 "67fe93e078ea64719fb4123a638cc798241fe70d1fa5d5e08e64751f69a06b82"

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
