require 'formula'

class Cvsync <Formula
  url 'ftp://ftp.cvsync.org/pub/cvsync/cvsync-0.24.19.tar.gz'
  homepage 'http://www.cvsync.org/'
  sha1 'a3c0673bf0f3b81b1eb45ac828a527d2a4e6d2f6'

  def install
    ENV['PREFIX'] = prefix
    ENV['MANDIR'] = man
    ENV['CVSYNC_DEFAULT_CONFIG'] = etc + 'cvsync.conf'
    ENV['CVSYNCD_DEFAULT_CONFIG'] = etc + 'cvsyncd.conf'
    ENV['HASH_TYPE'] = 'openssl'

    # Makefile from 2005 assumes Darwin doesn't define `socklen_t' and defines
    # it with a CC macro parameter making gcc unhappy about double define.
    inreplace 'mk/network.mk',
      /^CFLAGS \+= \-Dsocklen_t=int/, ''

    # Remove owner and group parameters from install.
    inreplace 'mk/base.mk',
      /^INSTALL_(.{3})_OPTS\?=.*/, 'INSTALL_\1_OPTS?= -c -m ${\1MODE}'

    # These paths must exist or "make install" fails.
    bin.mkpath
    lib.mkpath
    man1.mkpath

    system 'make install'
  end
end
