class Dropbear < Formula
  desc "Small SSH server/client for POSIX-based system"
  homepage "https://matt.ucc.asn.au/dropbear/dropbear.html"
  url "https://matt.ucc.asn.au/dropbear/releases/dropbear-2015.71.tar.bz2"
  mirror "https://dropbear.nl/mirror/dropbear-2015.71.tar.bz2"
  sha256 "376214169c0e187ee9f48ae1a99b3f835016ad5b98ede4bfd1cf581deba783af"

  bottle do
    cellar :any_skip_relocation
    sha256 "65d59887e37a85f8aaa8f6e4dcbb4245cdce2ba7669a602d3b3d38c761d9f2b4" => :el_capitan
    sha256 "00784cda726cf43d7dfe27d051d70c39ccb75199c4bd26583344133606ff74cb" => :yosemite
    sha256 "1ab60a4f052609e42ec4682ba27251b3ef7ecd324ed018644080e87d61c4c8c0" => :mavericks
  end

  head do
    url "https://github.com/mkj/dropbear.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  def install
    ENV.deparallelize

    if build.head?
      system "autoconf"
      system "autoheader"
    end
    system "./configure", "--prefix=#{prefix}",
                          "--enable-pam",
                          "--enable-zlib",
                          "--enable-bundled-libtom",
                          "--sysconfdir=#{etc}/dropbear"
    system "make"
    system "make", "install"
  end

  test do
    testfile = testpath/"testec521"
    system "#{bin}/dbclient", "-h"
    system "#{bin}/dropbearkey", "-t", "ecdsa", "-f", testfile, "-s", "521"
    assert testfile.exist?
  end
end
