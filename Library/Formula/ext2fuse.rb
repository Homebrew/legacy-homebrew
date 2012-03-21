require 'formula'

class Ext2fuse < Formula
  homepage 'http://sourceforge.net/projects/ext2fuse'
  url 'http://sourceforge.net/projects/ext2fuse/files/ext2fuse/0.8.1/ext2fuse-src-0.8.1.tar.gz'
  md5 '8926c6eeb9ea17846466ca4bd7143489'

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
