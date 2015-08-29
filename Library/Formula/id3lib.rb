class Id3lib < Formula
  desc "ID3 tag manipulation"
  homepage "http://id3lib.sourceforge.net/"

  stable do
    url "https://downloads.sourceforge.net/project/id3lib/id3lib/3.8.3/id3lib-3.8.3.tar.gz"
    sha256 "2749cc3c0cd7280b299518b1ddf5a5bcfe2d1100614519b68702230e26c7d079"

    patch do
      url "https://raw.githubusercontent.com/DomT4/scripts/c24f2952/Homebrew_Resources/MacPorts_Import/id3lib/id3lib-vbr-overflow.patch"
      mirror "https://trac.macports.org/export/112431/trunk/dports/audio/id3lib/files/id3lib-vbr-overflow.patch"
      sha256 "0ec91c9d89d80f40983c04147211ced8b4a4d8a5be207fbe631f5eefbbd185c2"
    end

    patch do
      url "https://raw.githubusercontent.com/DomT4/scripts/c24f2952/Homebrew_Resources/MacPorts_Import/id3lib/id3lib-main.patch"
      mirror "https://trac.macports.org/export/90780/trunk/dports/audio/id3lib/files/id3lib-main.patch"
      sha256 "83c8d2fa54e8f88b682402b2a8730dcbcc8a7578681301a6c034fd53e1275463"
    end
  end

  head ":pserver:anonymous:@id3lib.cvs.sourceforge.net:/cvsroot/id3lib",
    :using => :cvs, :module => "id3lib-devel"

  bottle do
    cellar :any
    revision 2
    sha256 "062c57d74fb0ffa2be7ee3266d204dcd963d91108750301879912cc65e907dd8" => :yosemite
    sha256 "c29d0ddd008b5f7a2d1fbf19faf675f8c08799ed98a6e8511b0cbd17d8959ffb" => :mavericks
    sha256 "2ce3337dbd9e051edbd6be7c899d11d741576817ed9f8d61d78d1ba3d21b90df" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  patch do
    url "https://raw.githubusercontent.com/DomT4/scripts/c24f2952/Homebrew_Resources/MacPorts_Import/id3lib/r112430/no-iomanip.h.patch"
    mirror "https://trac.macports.org/export/112430/trunk/dports/audio/id3lib/files/no-iomanip.h.patch"
    sha256 "da0bd9f3d17f1dd054720c17dfd15062eabdfc4d38126bb1b2ef5e8f39904925"
  end

  patch do
    url "https://raw.githubusercontent.com/DomT4/scripts/c24f2952/Homebrew_Resources/MacPorts_Import/id3lib/r112430/automake.patch"
    mirror "https://trac.macports.org/export/112430/trunk/dports/audio/id3lib/files/automake.patch"
    sha256 "c1ae2aa04baee7f92301cbed120340682e62e1f839bb61f8f6d3c459a7faf097"
  end

  patch do
    url "https://raw.githubusercontent.com/DomT4/scripts/c24f2952/Homebrew_Resources/MacPorts_Import/id3lib/r112430/boolcheck.patch"
    mirror "https://trac.macports.org/export/112430/trunk/dports/audio/id3lib/files/boolcheck.patch"
    sha256 "a7881dc25665f284798934ba19092d1eb45ca515a34e5c473accd144aa1a215a"
  end

  fails_with :llvm do
    build 2326
    cause "Segfault during linking"
  end

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
