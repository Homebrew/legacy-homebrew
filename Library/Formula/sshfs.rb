require 'formula'

class Sshfs < Formula
  homepage 'http://fuse.sourceforge.net/sshfs.html'
  url 'https://github.com/fuse4x/sshfs/archive/sshfs_2_4_0.tar.gz'
  sha1 '30b81ac7f32125088652937568d8886e3bb3f6e2'

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on :libtool

  depends_on 'pkg-config' => :build
  depends_on 'fuse4x'
  depends_on 'glib'
  depends_on :xcode

  bottle do
    cellar :any
    sha1 '9a227c8c85f410c48c95e766599d04fafd6c42b7' => :mavericks
    sha1 '9f40f3614b424be69c19b13a5cc0b22fe9566faf' => :mountain_lion
    sha1 '78164b5d1f374f9177017ccef88734d4af19d390' => :lion
  end

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
