require 'formula'

class Id3lib < Formula
  homepage 'http://id3lib.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/id3lib/id3lib/3.8.3/id3lib-3.8.3.tar.gz'
  sha1 'c92c880da41d1ec0b242745a901702ae87970838'

  head "cvs://:pserver:anonymous:@id3lib.cvs.sourceforge.net:/cvsroot/id3lib:id3lib-devel"

  bottle do
    cellar :any
    sha1 "3706bca1a75d73ded2efeff8aedeaea25cea3cb7" => :mavericks
    sha1 "9693062720327e9af5e73870a4dd954b5828c483" => :mountain_lion
    sha1 "ba892268a2bdd9e713017272b819de2501aad602" => :lion
  end

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build

  patch do
    url "https://trac.macports.org/export/112431/trunk/dports/audio/id3lib/files/id3lib-vbr-overflow.patch"
    sha1 "2fc0d348469980b30d7844dad63cac91ccd421c9"
  end

  patch do
    url "https://trac.macports.org/export/90780/trunk/dports/audio/id3lib/files/id3lib-main.patch"
    sha1 "8e52e21bd37fcd57bfaa8b1a8c11bf897d73a476"
  end

  patch do
    url "https://trac.macports.org/export/112430/trunk/dports/audio/id3lib/files/no-iomanip.h.patch"
    sha1 "d4d782608cf038fbd1adcf5d08324a9d1c49bc38"
  end

  patch do
    url "https://trac.macports.org/export/112430/trunk/dports/audio/id3lib/files/automake.patch"
    sha1 "86a83a2e993ccc2bb23a32837ec996d3a959a9a1"
  end

  patch do
    url "https://trac.macports.org/export/112430/trunk/dports/audio/id3lib/files/boolcheck.patch"
    sha1 "55a4db02c74825157ef5df62f10ed8c4173e7dc7"
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
