class Ipsumdump < Formula
  homepage "http://www.read.seas.harvard.edu/~kohler/ipsumdump/"
  url "http://www.read.seas.harvard.edu/~kohler/ipsumdump/ipsumdump-1.84.tar.gz"
  sha1 "3dc3ff9d97a65be25866d624a663be91e27d8628"
  head "https://github.com/kohler/ipsumdump.git"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/ipsumdump", "-c", "-r", "#{test_fixtures("test.pcap")}"
  end
end
