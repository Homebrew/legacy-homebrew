class Ipsumdump < Formula
  desc "Summarizes TCP/IP dump files into a self-describing ASCII format easily readable"
  homepage "http://www.read.seas.harvard.edu/~kohler/ipsumdump/"
  url "http://www.read.seas.harvard.edu/~kohler/ipsumdump/ipsumdump-1.85.tar.gz"
  sha256 "98feca0f323605a022ba0cabcd765a8fcad1b308461360a5ae6c4c293740dc32"
  head "https://github.com/kohler/ipsumdump.git"

  bottle do
    sha1 "5ae94f24b2a5bd37e86babecd1848ed18a8d2dcc" => :yosemite
    sha1 "139139a0c3fcc8f0e6fdedeb396e3e65b85b758e" => :mavericks
    sha1 "4acd0be3df8c6c81de7b9e28e20d93f84076f4fd" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/ipsumdump", "-c", "-r", "#{test_fixtures("test.pcap")}"
  end
end
