require 'formula'

class Scamper < Formula
  homepage 'http://www.wand.net.nz/scamper/'
  url 'http://www.wand.net.nz/scamper/scamper-cvs-20111202c.tar.gz'
  sha1 'eb0dc6bf13a0d568f65e079ad39be53c3e8457d9'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
