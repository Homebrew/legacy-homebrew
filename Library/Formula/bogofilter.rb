class Bogofilter < Formula
  desc "Mail filter via statistical analysis"
  homepage "http://bogofilter.sourceforge.net"
  url "https://downloads.sourceforge.net/project/bogofilter/bogofilter-1.2.4/bogofilter-1.2.4.tar.bz2"
  sha256 "e10287a58d135feaea26880ce7d4b9fa2841fb114a2154bf7da8da98aab0a6b4"

  depends_on "berkeley-db"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
