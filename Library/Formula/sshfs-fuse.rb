require 'formula'

class SshfsFuse <Formula
  url 'http://downloads.sourceforge.net/project/fuse/sshfs-fuse/2.2/sshfs-fuse-2.2.tar.gz'
  homepage 'http://fuse.sourceforge.net/sshfs.html'
  md5 '26e9206eb5169e87e6f95f54bc005a4f'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'gettext'

  def install
    ENV.append_to_cflags "-DDARWIN_SEMAPHORE_COMPAT"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def patches
    "http://macfuse.googlecode.com/svn/trunk/filesystems/sshfs/sshfs-fuse-2.2-macosx.patch"
  end

  def caveats
    <<-EOS.undent
    This depends on the MacFUSE installation from http://code.google.com/p/macfuse/
    MacFUSE must be installed prior to installing this formula.
    EOS
  end
end
