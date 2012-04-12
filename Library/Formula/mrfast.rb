require 'formula'

class Mrfast < Formula
  homepage 'http://mrfast.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/mrfast/mrfast/mrfast-2.1.0.3.tar.gz'
  md5 '32dfbfae84852ed7847fec0155cb55aa'

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=-c #{ENV.cflags}"
    bin.install 'mrfast'
  end

  def test
    actual = `#{bin}/mrfast -h`.split("\n").first
    expect = "mrFAST : Micro-Read Fast Alignment Search Tool."
    expect.eql? actual
  end
end
