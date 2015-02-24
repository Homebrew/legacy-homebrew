class Bcrypt < Formula
  homepage "http://bcrypt.sourceforge.net"
  url "http://bcrypt.sourceforge.net/bcrypt-1.1.tar.gz"
  sha1 "fd4c7c83fdc560f143bb0e0a8c9fb7aa57e69698"

  bottle do
    cellar :any
    sha1 "c762b0073e30fd3a8cb615b30d7b39668c8d672b" => :yosemite
    sha1 "03c15bc2a81e3ff43fddb2594428897b1c44bee1" => :mavericks
    sha1 "d48a408b10ce81e33f21301b9885e0e9878ddd63" => :mountain_lion
  end

  def install
    system "make", "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=-lz"
    bin.install "bcrypt"
    man1.install gzip("bcrypt.1")
  end

  test do
    (testpath/"test.txt").write("Hello World!")
    pipe_output("#{bin}/bcrypt -r test.txt", "12345678\n12345678\n")
    mv "test.txt.bfe", "test.out.txt.bfe"
    pipe_output("#{bin}/bcrypt -r test.out.txt.bfe", "12345678\n")
    assert_equal File.read("test.txt"), File.read("test.out.txt")
  end
end
