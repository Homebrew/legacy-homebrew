require 'formula'

class Mrfast < Formula
  homepage 'http://mrfast.sourceforge.net/'
  url 'http://sourceforge.net/projects/mrfast/files/mrfast/mrfast-2.5.0.2.tar.gz'
  sha1 '149d45a2ec9c5def879c20a2fac0799dc85d1606'

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
