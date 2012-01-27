require 'formula'

class Stormfs < Formula
  url 'https://github.com/downloads/benlemasurier/stormfs/stormfs-0.01.tar.gz'
  homepage 'https://github.com/benlemasurier/stormfs'
  md5 '99939ae58cb25bf081d769f6f1cf9180'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'fuse4x'
  depends_on 'curl' if MacOS.leopard?

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
