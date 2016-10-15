require 'formula'

class Spl < Formula
  homepage 'http://www.maczfs.org'
  # alpha-0.6.3 is the first release that will actually build on OS X
  url 'https://github.com/zfs-osx/spl/archive/alpha-0.6.3.tar.gz'
  sha1 'b9ff6d4d4b219fe443f44d629c4e379e82597d6b'

  head do
    url 'https://github.com/zfs-osx/spl.git'
  end

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool

  fails_with :gcc do
    cause 'Produces unstable builds.'
  end

  def install
    ENV.j1
    args = ["--prefix=#{prefix}"]
    system "./autogen.sh"
    system "./configure", *args
    system "make"

    kext_prefix.install "module/spl/spl.kext"
  end

  def caveats; <<-EOS.undent
    In order for SPL-dependent components (like zfs.kext) to work, the
    kernel extension must be installed by the root user:

      sudo /cp -rfX #{kext_prefix}/spl.kext /System/Library/Extensions
      sudo chown -R root:wheel /System/Library/Extensions/spl.kext

    If you wish to load the SPL extension now (as opposed to rebooting):

      sudo kextload /System/Library/Extensions/spl.kext

    If upgrading from a previous version of SPL, the old kernel extension
    will need to be unloaded before performing the steps above. First,
    check that no SPL-dependent components are running (e.g. mounted ZFS
    filesystems, the ZFS extension itself) and then unload the extension:

      sudo kextunload -b net.lundman.spl

    EOS
  end
end
