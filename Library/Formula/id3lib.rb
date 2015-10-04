class Id3lib < Formula
  desc "ID3 tag manipulation"
  homepage "http://id3lib.sourceforge.net/"
  revision 1

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
    sha256 "266926f3fe3593bd04db9b9ff200676aaeb879d1f855e289cc41d2b40d72a16d" => :el_capitan
    sha256 "6d255640321f499620cdac8c6645be5c74c6d67de9cf593506f5766b0adf9ddb" => :yosemite
    sha256 "0eaeb0ed5fe1a86af5ffa34d4d5a96b91b97ccfc525fd471dc38a63d2585ad77" => :mavericks
    sha256 "365639b9fd975033c6c22c592feb2bb332bd77612142080beee316ef83d6bb57" => :mountain_lion
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

  # fixes Unicode display problem in easytag: see Homebrew/homebrew-x11#123
  patch do
    url "https://git.gnome.org/browse/easytag/plain/src/tags/id3lib/patch_id3lib_3.8.3_UTF16_writing_bug.diff"
    sha256 "71c79002d9485965a3a93e87ecbd7fed8f89f64340433b7ccd263d21385ac969"
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
