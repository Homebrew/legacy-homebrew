require 'formula'

class Mrfast < Formula
  homepage 'http://mrfast.sourceforge.net/'
  url 'http://sourceforge.net/projects/mrfast/files/mrfast/mrfast-2.5.0.0.tar.gz'
  sha1 'ef3445317f80dc4e2db7106d3dd3699498f7ec62'

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
