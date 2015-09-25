class Bro < Formula
  desc "Network security monitor"
  homepage "https://www.bro.org"
  url "https://www.bro.org/downloads/release/bro-2.4.tar.gz"
  sha256 "740c0d0b0bec279c2acef5e1b6b4d0016c57cd02a729f5e2924ae4a922e208b2"
  head "https://github.com/bro/bro.git"

  bottle do
    revision 1
    sha256 "3e09423271e6ba40ab8a99ffeb28f111394d2dd93f9ba797f039e4e3c039c6f9" => :yosemite
    sha256 "79e2b987df64e6aaaadc92527ee676d703fc2f7183288f240da89858f822fc02" => :mavericks
    sha256 "1c1907a84780068d79e41739b4b62b73ca837bb1688f45f8f6b1ec824f87ec81" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "openssl"
  depends_on "geoip" => :recommended

  def install
    system "./configure", "--prefix=#{prefix}", "--with-openssl=#{Formula["openssl"].opt_prefix}",
                          "--localstatedir=#{var}", "--conf-files-dir=#{etc}"
    system "make", "install"
  end

  test do
    system "#{bin}/bro", "--version"
  end
end
