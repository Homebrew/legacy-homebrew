require 'formula'

class Id3lib < Formula
  homepage 'http://id3lib.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/id3lib/id3lib/3.8.3/id3lib-3.8.3.tar.gz'
  sha1 'c92c880da41d1ec0b242745a901702ae87970838'

  head "cvs://:pserver:anonymous:@id3lib.cvs.sourceforge.net:/cvsroot/id3lib:id3lib-devel"

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build

  def patches
    p = []
    p << "https://trac.macports.org/export/112431/trunk/dports/audio/id3lib/files/id3lib-vbr-overflow.patch"
    p << "https://trac.macports.org/export/90780/trunk/dports/audio/id3lib/files/id3lib-main.patch"
    p << "https://trac.macports.org/export/112430/trunk/dports/audio/id3lib/files/no-iomanip.h.patch"
    p << "https://trac.macports.org/export/112430/trunk/dports/audio/id3lib/files/automake.patch"
    p << "https://trac.macports.org/export/112430/trunk/dports/audio/id3lib/files/boolcheck.patch"
  end

  fails_with :llvm do
    build 2326
    cause "Segfault during linking"
  end

  def install
    system "autoreconf -fi"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
