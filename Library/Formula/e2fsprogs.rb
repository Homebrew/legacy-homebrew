require 'formula'

class E2fsprogs < Formula
  homepage 'http://e2fsprogs.sourceforge.net/'
  url 'http://downloads.sourceforge.net/e2fsprogs/e2fsprogs-1.42.7.tar.gz'
  sha1 '897ed5bab4f021834d00ec047ed83766d56ce0a8'

  head 'https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git'

  keg_only "This brew installs several commands which override OS X-provided file system commands."

  depends_on 'pkg-config' => :build
  depends_on 'gettext'

  def patches
    # MacPorts patch to compile libs correctly.
    {:p0 => [
      "https://trac.macports.org/export/92117/trunk/dports/sysutils/e2fsprogs/files/patch-lib__Makefile.darwin-lib"
    ]}
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
    system "make install-libs"
  end
end
