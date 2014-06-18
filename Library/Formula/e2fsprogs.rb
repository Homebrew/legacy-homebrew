require 'formula'

class E2fsprogs < Formula
  homepage 'http://e2fsprogs.sourceforge.net/'
  url 'https://downloads.sourceforge.net/e2fsprogs/e2fsprogs-1.42.10.tar.gz'
  sha1 '06eba8a78ce1d5032fdcaf34f09025f01ceaca79'

  head 'https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git'

  keg_only "This brew installs several commands which override OS X-provided file system commands."

  depends_on 'pkg-config' => :build
  depends_on 'gettext'

  # MacPorts patch to compile libs correctly.
  # Fix a bare return for clang.
  patch :p0 do
    url "https://trac.macports.org/export/92117/trunk/dports/sysutils/e2fsprogs/files/patch-lib__Makefile.darwin-lib"
    sha1 "d6ebd54e504187a6f59e0e0f347aa373692b78d9"
  end

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}", "--disable-e2initrd-helper"
    system "make"
    system "make install"
    system "make install-libs"
  end
end
