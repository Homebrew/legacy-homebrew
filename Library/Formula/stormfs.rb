require 'formula'

class Stormfs < Formula
  url 'https://github.com/downloads/benlemasurier/stormfs/stormfs-0.01.tar.gz'
  homepage 'https://github.com/benlemasurier/stormfs'
  md5 '14796c891d0dd431d807add766f69e39'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'fuse4x'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
