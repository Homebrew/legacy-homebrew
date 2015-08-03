class Rdup < Formula
  desc "Utility to create a file list suitable for making backups"
  homepage "http://archive.miek.nl/projects/rdup/index.html"
  url "http://archive.miek.nl/projects/rdup/rdup-1.1.14.tar.bz2"
  sha256 "b25e2b0656d2e6a9cb97a37f493913c4156468d4c21cea15a9a0c7b353e3742a"
  revision 1

  depends_on "pkg-config" => :build
  depends_on "nettle"
  depends_on "pcre"
  depends_on "glib"
  depends_on "libarchive"
  depends_on "mcrypt"

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
