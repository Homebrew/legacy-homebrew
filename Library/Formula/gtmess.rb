class Gtmess < Formula
  desc "Console MSN messenger client"
  homepage "http://gtmess.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gtmess/gtmess/0.97/gtmess-0.97.tar.gz"
  sha256 "606379bb06fa70196e5336cbd421a69d7ebb4b27f93aa1dfd23a6420b3c6f5c6"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
