class Ophcrack < Formula
  desc "Microsoft Windows password cracker using rainbow tables"
  homepage "http://ophcrack.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ophcrack/ophcrack/3.6.0/ophcrack-3.6.0.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/o/ophcrack/ophcrack_3.6.0.orig.tar.bz2"
  sha256 "79219baa03afd7e52bc6d365dd5a445bc73dfac2e88216e7b050ad7749191893"
  revision 1

  bottle do
    cellar :any
    sha256 "12b73c51c2f72e98037761d47cc42077d03d2aacfb9e58ec2325ae8a621bf423" => :mavericks
    sha256 "3921cfce1b5df8eb56f38465b141aca8a314246e78c4245dd9a4b2a63219106e" => :mountain_lion
    sha256 "bd22912ade4629ed93d34dc0431804db298184784ed981b6d028243e8563136f" => :lion
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
