require 'formula'

class FuseExt2 < Formula
  homepage 'http://sourceforge.net/projects/fuse-ext2/'
  head 'svn://svn.code.sf.net/p/fuse-ext2/code/trunk'
  url 'http://downloads.sourceforge.net/project/fuse-ext2/fuse-ext2/fuse-ext2-0.0.7/fuse-ext2-0.0.7.tar.gz'
  sha1 'cdfef525838d2de07a4da6d60b65efce5a1cffa0'

  depends_on "osxfuse"

  depends_on :automake
  depends_on :libtool
  depends_on :autoconf
  depends_on 'pkg-config' => :build


  def patches
     [
        # updates for os x 10.7 and later and osxfuse
        "https://gist.github.com/morpheby/8155045/raw/d270d76a83a46aad78d165e9b2776a4847c4508d/fuse_ext2-osx.patch",

        # Alows unprivileged install
        "https://gist.github.com/morpheby/8155349/raw/8b5888f55ee62589d3f3aad2282ebaa8e50f090d/fuse_ext2-brew.patch",

        # There is stray code in makefile, used only for linux
        "https://gist.github.com/morpheby/ee297745f5973efe508a/raw/ef192f67a205c6b0af621f12480886f3c7b1f29b/fuse_ext2-install-hook.patch"
     ]
  end

  def caveats
     "You need to execute following commands after installation, to install fuse_ext2 to your system:

       sudo ln -sf #{prefix}/System/Library/Filesystems/fuse-ext2.fs /System/Library/Filesystems/fuse-ext2.fs
     "
  end

  def install
    system "autoreconf", "--install", "--force"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "CFLAGS=-DNO_INLINE_FUNCS"

    system "make"

    system "make", "install"
  end

  test do
    system "#{bin}/fuse-ext2.install", "-i"
  end
end

