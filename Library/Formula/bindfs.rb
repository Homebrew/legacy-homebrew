require 'formula'

class Bindfs < Formula
  homepage 'http://code.google.com/p/bindfs/'
  url 'http://bindfs.googlecode.com/files/bindfs-1.12.tar.gz'
  sha1 'e4d5d9ab3056c06e1e8b9fe423222de86cce46cf'

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
