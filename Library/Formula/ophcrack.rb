class Ophcrack < Formula
  desc "Microsoft Windows password cracker using rainbow tables"
  homepage "http://ophcrack.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ophcrack/ophcrack/3.6.0/ophcrack-3.6.0.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/o/ophcrack/ophcrack_3.6.0.orig.tar.bz2"
  sha256 "79219baa03afd7e52bc6d365dd5a445bc73dfac2e88216e7b050ad7749191893"
  revision 1

  bottle do
    cellar :any
    sha1 "708bc9a7d0d55c7bc40c658193b7f8c132a4b03a" => :mavericks
    sha1 "dada805fde40ab311f1819bc51b1280cdc224bfe" => :mountain_lion
    sha1 "4c4e177a30674d11e10fd825d3567d41773d952b" => :lion
  end

  depends_on "openssl"

  def install
    system "./configure", "--disable-debug",
                          "--disable-gui",
                          "--with-libssl=#{Formula["openssl"].opt_prefix}",
                          "--prefix=#{prefix}"

    system "make"
    system "make", "-C", "src", "install"
  end

  test do
    system "#{bin}/ophcrack", "-h"
  end
end
