require 'formula'

class Bindfs < Formula
  url 'http://bindfs.googlecode.com/files/bindfs-1.9.tar.gz'
  homepage 'http://code.google.com/p/bindfs/'
  sha1 'cf8c2acf67f0e98593ec9f88ad00e12bbbc84f2e'

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
