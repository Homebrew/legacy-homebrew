require 'formula'

class Rdup < Formula
  homepage 'http://archive.miek.nl/projects/rdup/index.html'
  url 'http://archive.miek.nl/projects/rdup/rdup-1.1.14.tar.bz2'
  sha1 '49dc7570122bfa362f36a26a2ffa8bfe8ad55182'
  revision 1

  depends_on 'pkg-config' => :build
  depends_on 'nettle'
  depends_on 'pcre'
  depends_on 'glib'
  depends_on 'libarchive'
  depends_on 'mcrypt'

  def install
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}"

    # let rdup know that we actually have dirfd
    system "echo '#define HAVE_DIRFD 1' >> config.h"

    system "make", "install"
  end

  test do
    # tell rdup to archive itself, then let rdup-tr make a tar archive of it,
    # and test with tar and grep whether the resulting tar archive actually
    # contains rdup
    system "#{bin}/rdup /dev/null #{bin}/rdup | #{bin}/rdup-tr -O tar | tar tvf - | grep #{bin}/rdup"
  end
end
