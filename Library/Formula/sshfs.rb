require 'brewkit'

class Sshfs <Formula
  @url='http://downloads.sourceforge.net/project/fuse/sshfs-fuse/2.2/sshfs-fuse-2.2.tar.gz'
  # This is the original project homepage, but we link to something more useful for OS X users
  #@homepage='http://fuse.sourceforge.net/sshfs.html'
  @homepage='http://code.google.com/p/macfuse/wiki/MACFUSE_FS_SSHFS'
  @md5='26e9206eb5169e87e6f95f54bc005a4f'

  def patches
    "http://macfuse.googlecode.com/svn/tags/macfuse-2.0.3|2/filesystems/sshfs/sshfs-fuse-2.2-macosx.patch"
  end

  depends_on 'pkg-config'
  depends_on 'glib'
  depends_on 'macfuse'

  def install
    # Steal compile flags from macfuse_buildtool.sh
    # Except that those flags include "-DSSH_NODELAY_WORKAROUND" which causes a bogus
    # warning message to be printed to the console, so cut out that crap.
    ENV['CFLAGS'] += " -D__FreeBSD__=10 -DDARWIN_SEMAPHORE_COMPAT"
    system "./configure --prefix='#{prefix}' --disable-dependency-tracking"
    system "make"
    system "make install"
  end
end
