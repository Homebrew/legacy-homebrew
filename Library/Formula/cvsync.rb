class Cvsync < Formula
  desc "Portable CVS repository synchronization utility"
  homepage "http://www.cvsync.org/"
  url "http://www.cvsync.org/dist/cvsync-0.24.19.tar.gz"
  sha256 "75d99fc387612cb47141de4d59cb3ba1d2965157230f10015fbaa3a1c3b27560"

  depends_on "openssl"

  def install
    ENV["PREFIX"] = prefix
    ENV["MANDIR"] = man
    ENV["CVSYNC_DEFAULT_CONFIG"] = etc/"cvsync.conf"
    ENV["CVSYNCD_DEFAULT_CONFIG"] = etc/"cvsyncd.conf"
    ENV["HASH_TYPE"] = "openssl"

    # Makefile from 2005 assumes Darwin doesn't define `socklen_t' and defines
    # it with a CC macro parameter making gcc unhappy about double define.
    inreplace "mk/network.mk",
      /^CFLAGS \+= \-Dsocklen_t=int/, ""

    # Remove owner and group parameters from install.
    inreplace "mk/base.mk",
      /^INSTALL_(.{3})_OPTS\?=.*/, 'INSTALL_\1_OPTS?= -c -m ${\1MODE}'

    # These paths must exist or "make install" fails.
    bin.mkpath
    lib.mkpath
    man1.mkpath

    system "make", "install"
  end

  test do
    assert_match "#{version}", shell_output("#{bin}/cvsync -h 2>&1", 1)
  end
end
