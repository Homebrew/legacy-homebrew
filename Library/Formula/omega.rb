require "formula"

class Omega < Formula
  homepage "http://xapian.org"
  url "http://oligarchy.co.uk/xapian/1.2.18/xapian-omega-1.2.18.tar.xz"
  sha1 "9b0060c639ebb53e9b2dd6928019e06d0fd24ced"

  bottle do
    sha1 "afdc13cb8c4a768df40606f12943ef56a314e3d3" => :mavericks
    sha1 "7ea1a55103d2367a4d033508336274e0181a64bd" => :mountain_lion
    sha1 "55217805d501af8d6bfac7db3a65e3b403d4c0b6" => :lion
  end

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
