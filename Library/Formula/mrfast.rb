require 'formula'

class Mrfast < Formula
  homepage 'http://mrfast.sourceforge.net/'
  url 'http://sourceforge.net/projects/mrfast/files/mrfast/mrfast-2.1.0.6.tar.gz'
  sha1 '13e9ac030052f3930f7d2db1174070a2f2e29dbd'

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
