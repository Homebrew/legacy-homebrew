require 'formula'

class E2fsprogs < Formula
  homepage 'http://e2fsprogs.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.42.2/e2fsprogs-1.42.2.tar.gz'
  md5 '04f4561a54ad0419248316a00c016baa'
  head 'https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git', :using => :git

  keg_only "This brew installs several commands which override OS X-provided file system commands."

  depends_on 'pkg-config' => :build

  def patches
    # MacPorts patch to compile libs correctly.
    p = {:p0 => [
      "https://trac.macports.org/export/92117/trunk/dports/sysutils/e2fsprogs/files/patch-lib__Makefile.darwin-lib"
    ]}

    # MacPorts patch to allow compilation on Leopard.
    if MacOS.leopard?
      p[:p0] << "https://trac.macports.org/export/92117/trunk/dports/sysutils/e2fsprogs/files/patch-lib-ext2fs-inline.c.diff"
    end

    p
  end

  def install
    ENV.append_to_cflags "--std=gnu89 -Wno-return-type" if ENV.compiler == :clang
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
    system "make install-libs"
  end
end
