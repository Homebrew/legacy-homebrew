class Rdup < Formula
  desc "Utility to create a file list suitable for making backups"
  homepage "https://archive.miek.nl/projects/rdup/"
  url "https://archive.miek.nl/projects/rdup/rdup-1.1.14.tar.bz2"
  sha256 "b25e2b0656d2e6a9cb97a37f493913c4156468d4c21cea15a9a0c7b353e3742a"
  revision 2

  bottle do
    cellar :any
    sha256 "30ae4e73e58b80d081378978a93962ef798eb32ecc5b14eb015f707c766ee161" => :el_capitan
    sha256 "a61678fecdd52fef40014327b604d03a96b506c7552ed2e2b8d22934d37cdbbb" => :yosemite
    sha256 "979a3ef9ddaad9545d9cc9f943aef2fa0c7d69fabf05abd742740620239a8271" => :mavericks
  end

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
