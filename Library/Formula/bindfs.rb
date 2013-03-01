require 'formula'

class Bindfs < Formula
  homepage 'http://code.google.com/p/bindfs/'
  url 'http://bindfs.googlecode.com/files/bindfs-1.11.tar.gz'
  sha1 '9bb15d3b2d64cae4da936be13625010b3cd9f8ef'

  depends_on 'pkg-config' => :build
  depends_on 'fuse4x'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/bindfs", "-V"
  end
end
