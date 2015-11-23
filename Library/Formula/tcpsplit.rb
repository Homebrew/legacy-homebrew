class Tcpsplit < Formula
  desc "Break a packet trace into some number of sub-traces"
  homepage "http://www.icir.org/mallman/software/tcpsplit/"
  url "http://www.icir.org/mallman/software/tcpsplit/tcpsplit-0.2.tar.gz"
  sha256 "885a6609d04eb35f31f1c6f06a0b9afd88776d85dec0caa33a86cef3f3c09d1d"

  def install
    system "make"
    bin.install "tcpsplit"
  end
end
