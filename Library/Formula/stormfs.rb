require 'formula'

class Stormfs < Formula
  url 'https://github.com/downloads/benlemasurier/stormfs/stormfs-0.01.tar.gz'
  homepage 'https://github.com/benlemasurier/stormfs'
  sha1 'd86bb74beb4b4343b63b3eda3e6bd6f4db982bbb'

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
