class Mergelog < Formula
  desc "Merges httpd logs from web servers behind round-robin DNS"
  homepage "http://mergelog.sourceforge.net/"
  url "https://downloads.sourceforge.net/mergelog/mergelog-4.5.tar.gz"
  sha256 "fd97c5b9ae88fbbf57d3be8d81c479e0df081ed9c4a0ada48b1ab8248a82676d"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/mergelog", "/dev/null"
  end
end
