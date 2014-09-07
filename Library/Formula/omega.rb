require "formula"

class Omega < Formula
  homepage "http://xapian.org"
  url "http://oligarchy.co.uk/xapian/1.2.18/xapian-omega-1.2.18.tar.xz"
  sha1 "9b0060c639ebb53e9b2dd6928019e06d0fd24ced"

  depends_on "pcre"
  depends_on "xapian"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/omindex", "--db", "./test", "--url", "/", "#{share}/doc/xapian-omega"
    assert File.exist?("./test/flintlock")
  end
end
