require 'formula'

class E2fsprogs < Formula
  url 'http://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.42.2/e2fsprogs-1.42.2.tar.gz'
  homepage 'http://e2fsprogs.sourceforge.net/'
  md5 '04f4561a54ad0419248316a00c016baa'
  head 'https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git', :using => :git

  keg_only "This brew installs several commands which override OS X-provided file system commands."

  def install
    ENV.append_to_cflags "--std=gnu89 -Wno-return-type" if ENV.compiler == :clang
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
