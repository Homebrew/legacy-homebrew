require 'formula'

class Pcal < Formula
  homepage 'http://pcal.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/pcal/pcal/pcal-4.11.0/pcal-4.11.0.tgz'
  sha1 '214bcb4c4b7bc986ae495c96f2ab169233a7f973'

  def install
    ENV.deparallelize
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"

    # Install manually; easier than fixing paths in makefile
    bin.install 'exec/pcal'
    man1.install gzip('doc/pcal.man') => 'pcal.1.gz'
  end

  def test
    system "#{bin}/pcal"
  end
end
