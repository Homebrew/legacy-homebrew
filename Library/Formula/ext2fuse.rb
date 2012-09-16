require 'formula'

class Ext2fuse < Formula
  homepage 'http://sourceforge.net/projects/ext2fuse'
  url 'http://sourceforge.net/projects/ext2fuse/files/ext2fuse/0.8.1/ext2fuse-src-0.8.1.tar.gz'
  sha1 '6a13fce7842ead1485a4f48cb57c1272d990b5a5'

  depends_on 'fuse4x'
  depends_on 'e2fsprogs'

  def install
    ENV.append 'LIBS', "-lfuse4x"
    ENV.append 'CPPFLAGS', "-DHAVE_TYPE_SSIZE_T=1"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
