class Rdup < Formula
  desc "Utility to create a file list suitable for making backups"
  homepage "https://archive.miek.nl/projects/rdup/"
  url "https://archive.miek.nl/projects/rdup/rdup-1.1.14.tar.bz2"
  sha256 "b25e2b0656d2e6a9cb97a37f493913c4156468d4c21cea15a9a0c7b353e3742a"
  revision 2

  bottle do
    cellar :any
    sha256 "9ea24b36882c48e95dd8c8f8653ee9568ce1bc73e5feaf1cc0c815939776f1bf" => :el_capitan
    sha256 "163ee2ee0b3a2ada8119779d071d5dd52bbf26c242f0114e39b42d5ce47bb352" => :yosemite
    sha256 "955fc1c20fd4d9daddef07f0cc4f8475f310040ed797ba0e00e1a76f91a74a46" => :mavericks
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
