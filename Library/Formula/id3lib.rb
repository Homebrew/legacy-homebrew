class Id3lib < Formula
  desc "ID3 tag manipulation"
  homepage 'http://id3lib.sourceforge.net/'

  stable do
    url 'https://downloads.sourceforge.net/project/id3lib/id3lib/3.8.3/id3lib-3.8.3.tar.gz'
    sha1 'c92c880da41d1ec0b242745a901702ae87970838'

    patch do
      url "https://trac.macports.org/export/112431/trunk/dports/audio/id3lib/files/id3lib-vbr-overflow.patch"
      sha1 "2fc0d348469980b30d7844dad63cac91ccd421c9"
    end

    patch do
      url "https://trac.macports.org/export/90780/trunk/dports/audio/id3lib/files/id3lib-main.patch"
      sha1 "8e52e21bd37fcd57bfaa8b1a8c11bf897d73a476"
    end
  end

  head ":pserver:anonymous:@id3lib.cvs.sourceforge.net:/cvsroot/id3lib",
    :using => :cvs, :module => "id3lib-devel"

  bottle do
    cellar :any
    revision 1
    sha1 "ccb2a5ec637f99a36996920c1bbd9d284bb91958" => :yosemite
    sha1 "9db89ba6ca30f1ae05d7af44ad6ba82931a88c42" => :mavericks
  end

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build

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
