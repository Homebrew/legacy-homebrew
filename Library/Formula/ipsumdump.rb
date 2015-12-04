class Ipsumdump < Formula
  desc "Summarizes TCP/IP dump files into a self-describing ASCII format easily readable"
  homepage "http://www.read.seas.harvard.edu/~kohler/ipsumdump/"
  url "http://www.read.seas.harvard.edu/~kohler/ipsumdump/ipsumdump-1.85.tar.gz"
  sha256 "98feca0f323605a022ba0cabcd765a8fcad1b308461360a5ae6c4c293740dc32"
  head "https://github.com/kohler/ipsumdump.git"

  bottle do
    sha256 "dd85d17c5ad0c0c54faee81f640f5089756b17f4ee94d257cb6990159eaa0489" => :yosemite
    sha256 "470b7134576942b195a5643d5d59f7f6aba90ac0e61be7bbff57b2f47b6bf87c" => :mavericks
    sha256 "b6fcabd37713036c619cdb7c0d12a2821c511ec640dac3e97f4d2806b1386e45" => :mountain_lion
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
