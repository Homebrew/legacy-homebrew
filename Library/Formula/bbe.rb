class Bbe < Formula
  desc "Sed-like editor for binary files"
  homepage "http://bbe-.sourceforge.net"
  url "https://downloads.sourceforge.net/project/bbe-/bbe/0.2.2/bbe-0.2.2.tar.gz"
  sha256 "baaeaf5775a6d9bceb594ea100c8f45a677a0a7d07529fa573ba0842226edddb"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
