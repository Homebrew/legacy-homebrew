require 'formula'

class Sshfs < Formula
  homepage 'http://fuse.sourceforge.net/sshfs.html'
  url 'https://github.com/fuse4x/sshfs/tarball/sshfs_2_4_0'
  sha1 '37a9a49a3042fad43f168f25454b56060a48e210'

  depends_on :automake
  depends_on :libtool

  depends_on 'pkg-config' => :build
  depends_on 'fuse4x'
  depends_on 'glib'

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
