require "formula"

class Lynx < Formula
  homepage "http://lynx.isc.org/release/"
  url "http://lynx.isc.org/current/lynx2.8.8rel.2.tar.bz2"
  version "2.8.8rel.2"
  sha1 "65bbf95627c88723bbb5880155e5fe01c2753d0c"
  revision 1

  bottle do
    sha1 "445ce7a7d6397e6edf7c5a401ff12ef05c9f88c5" => :mavericks
    sha1 "d8eb643b68dfea9197e8223b487ee54c5a0d15f0" => :mountain_lion
    sha1 "02a2c83433f01ae6b8af18a4222a16b590a29a38" => :lion
  end

  depends_on "openssl"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-echo",
                          "--enable-default-colors",
                          "--with-zlib",
                          "--with-bzlib",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}",
                          "--enable-ipv6"
    system "make", "install"
  end

  test do
    system "#{bin}/lynx", "-dump", "http://checkip.dyndns.org"
  end
end
