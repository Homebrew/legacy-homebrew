require 'formula'

class Bindfs < Formula
  homepage 'http://bindfs.org/'
  url 'http://bindfs.org/downloads/bindfs-1.12.3.tar.gz'
  sha1 'fafdf47d9461dcad385d091b2732f97ffac67079'

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
