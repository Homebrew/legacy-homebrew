require 'formula'

class LibarchiveHeader < Formula
  url 'https://raw.github.com/libarchive/libarchive/8076b31490c90aaf0edccecf760004c30bd95edc/libarchive/archive.h'
  sha1 '03c57e135cad9ca9d52604324d798ca1115838ce'
  version '3.0.4'
end
class LibarchiveEntryHeader < Formula
  url 'https://raw.github.com/libarchive/libarchive/8076b31490c90aaf0edccecf760004c30bd95edc/libarchive/archive_entry.h'
  sha1 '7eaee18321409fbb249cb59e9997757c740d7ecf'
  version '3.0.4'
end

class Rdup < Formula
  homepage 'http://miek.nl/projects/rdup/index.html'
  url 'http://miek.nl/projects/rdup/rdup-1.1.14.tar.bz2'
  sha1 '49dc7570122bfa362f36a26a2ffa8bfe8ad55182'

  depends_on 'pkg-config' => :build
  depends_on 'automake' => :build
  depends_on 'nettle'
  depends_on 'pcre'
  depends_on 'glib'

  def install
    ENV.deparallelize
    # to pick up locally downloaded libarchive headers
    ENV.append 'CFLAGS', "-I."

    system "./configure", "--prefix=#{prefix}"

    # let rdup know that we actually have dirfd
    system "echo '#define HAVE_DIRFD 1' >> config.h"

    # get required libarchive headers (they don't come with OS X,
    #   although libarchive itself is there)
    LibarchiveHeader.new.brew { cp "archive.h", buildpath }
    LibarchiveEntryHeader.new.brew { cp "archive_entry.h", buildpath }

    system "make", "install"
  end

  def test
    # tell rdup to archive itself, then let rdup-tr make a tar archive of it,
    # and test with tar and grep whether the resulting tar archive actually
    # contains rdup
    system "#{bin}/rdup /dev/null #{bin}/rdup | #{bin}/rdup-tr -O tar | tar tvf - | grep #{bin}/rdup"
  end
end
