class Dropbear < Formula
  desc "Small SSH server/client for POSIX-based system"
  homepage "https://matt.ucc.asn.au/dropbear/dropbear.html"
  url "https://matt.ucc.asn.au/dropbear/releases/dropbear-2015.71.tar.bz2"
  mirror "https://dropbear.nl/mirror/dropbear-2015.71.tar.bz2"
  sha256 "376214169c0e187ee9f48ae1a99b3f835016ad5b98ede4bfd1cf581deba783af"

  bottle do
    cellar :any
    sha256 "baae48ce3b4af952145539fe12ad0ab814a6113d477464b8dcf4f020185532d6" => :yosemite
    sha256 "22d15c60481e17846597b5b3f1f4a027227a17542e4bde27079a7b4df4e27c02" => :mavericks
    sha256 "62ad63d8f6acf1a8ca75705b1beee59fb06900ef3e4a8a2ccb4752b4c9877ed7" => :mountain_lion
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
