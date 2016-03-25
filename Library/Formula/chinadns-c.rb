class ChinadnsC < Formula
  desc "Port of ChinaDNS to C: fix irregularities with DNS in China"
  homepage "https://github.com/clowwindy/ChinaDNS-C"
  url "https://github.com/clowwindy/ChinaDNS/releases/download/1.3.2/chinadns-1.3.2.tar.gz"
  sha256 "abfd433e98ac0f31b8a4bd725d369795181b0b6e8d1b29142f1bb3b73bbc7230"

  bottle do
    cellar :any_skip_relocation
    sha256 "a620bce8421a9773233c51886c6845995569a1fda80e252efa86f6271c1d274c" => :el_capitan
    sha256 "329351a4f82e4f871cbc2b384902b0c84040bd1df222970d67be7513bbead207" => :yosemite
    sha256 "4266825a8ecbb6a84d459b41465fe9318a918b171880ac8ddfd8bdf3e37573d1" => :mavericks
    sha256 "c994af6ca279fa06b42ca3a851d550a04d279b2337c06fb21e91a0fe42708036" => :mountain_lion
  end

  head do
    url "https://github.com/clowwindy/ChinaDNS.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "chinadns", "-h"
  end
end
