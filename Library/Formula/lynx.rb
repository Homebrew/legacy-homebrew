class Lynx < Formula
  desc "Text-based web browser"
  homepage "http://lynx.isc.org/release/"
  url "http://lynx.isc.org/current/lynx2.8.8rel.2.tar.bz2"
  version "2.8.8rel.2"
  sha256 "6980e75cf0d677fd52c116e2e0dfd3884e360970c88c8356a114338500d5bee7"
  revision 1

  bottle do
    revision 1
    sha1 "5cec5cb413a991777ab1e8ede47059935feae1ca" => :mavericks
    sha1 "afd1846fe40fc0bac8a4f54d5c06ded1d4eb3725" => :mountain_lion
    sha1 "1ce39f3889f2b4e9a7f805236097f56fdbcf0fed" => :lion
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
