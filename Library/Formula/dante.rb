class Dante < Formula
  desc "SOCKS server and client, implementing RFC 1928 and related standards"
  homepage "https://www.inet.no/dante/"
  url "https://www.inet.no/dante/files/dante-1.4.1.tar.gz"
  mirror "ftp://ftp.inet.no/pub/socks/dante-1.4.1.tar.gz"
  sha256 "b6d232bd6fefc87d14bf97e447e4fcdeef4b28b16b048d804b50b48f261c4f53"

  bottle do
    cellar :any
    revision 1
    sha256 "317f720310f59b8c3c8b12e5b971829e7c2f8513832bc1782ec01c8d598e529d" => :el_capitan
    sha256 "610a391e6e28955b31a4f7a288ad446103e745a938c3d68f3082ff5fe1863574" => :yosemite
    sha256 "66d48707c1e9d1fd7a891a145c4848812f5563c38357434d8dccb195b5bd7b8a" => :mavericks
  end

  depends_on "miniupnpc" => :optional

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/dante"
    system "make", "install"
  end

  test do
    system "#{sbin}/sockd", "-v"
  end
end
