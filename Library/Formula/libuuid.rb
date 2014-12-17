class Libuuid < Formula
  homepage "https://sourceforge.net/projects/libuuid/"
  url "https://downloads.sourceforge.net/project/libuuid/libuuid-1.0.3.tar.gz"
  sha1 "46eaedb875ae6e63677b51ec583656199241d597"

  conflicts_with "ossp-uuid", :because => "both install lib/libuuid.a"

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end
end
