require 'formula'

class Sshfs < Formula
  homepage 'http://fuse.sourceforge.net/sshfs.html'
  url 'https://github.com/osxfuse/sshfs/archive/osxfuse-sshfs-2.4.1.tar.gz'
  sha1 'cf614508db850a719529dec845ae59309f8a79c2'

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on :libtool

  depends_on 'pkg-config' => :build
  depends_on 'osxfuse'
  depends_on 'glib'
  depends_on :xcode

  def install
    # Compatibility with Automake 1.13 and newer.
    inreplace 'configure.ac', 'AM_CONFIG_HEADER', 'AC_CONFIG_HEADERS'

    system "autoreconf", "--force", "--install"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Make sure to follow the directions given by `brew info fuse4x-kext`
    before trying to use a FUSE-based filesystem.
    EOS
  end
end
