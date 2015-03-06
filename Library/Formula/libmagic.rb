class Libmagic < Formula
  homepage "http://www.darwinsys.com/file/"
  url "ftp://ftp.astron.com/pub/file/file-5.22.tar.gz"
  mirror "https://fossies.org/unix/misc/file-5.22.tar.gz"
  sha1 "20fa06592291555f2b478ea2fb70b53e9e8d1f7c"

  bottle do
    revision 3
    sha256 "5aa7bd2a3c36d26fdb8a00dcc1ea6c17527de894466f97613ec733f6c5e2097b" => :yosemite
    sha256 "3ddce5fc42db2d11a71225fb6df8649f5e01d688856e67c53be1af888957ba1f" => :mavericks
    sha256 "ff20fdc480f7782f4080331d5f0ebff18ac5e8fa8f6a7df0389d430bd70cd423" => :mountain_lion
  end

  option :universal

  depends_on :python => :optional

  def install
    ENV.universal_binary if build.universal?

    # Clean up "src/magic.h" as per http://bugs.gw.com/view.php?id=330
    rm "src/magic.h"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-fsect-man5",
                          "--enable-static"
    system "make", "install"

    if build.with? "python"
      cd "python" do
        system "python", *Language::Python.setup_install_args(prefix)
      end
    end

    # Don't dupe this system utility
    rm bin/"file"
    rm man1/"file.1"
  end
end
