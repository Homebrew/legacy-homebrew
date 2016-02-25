class Libmatroska < Formula
  desc "Extensible, open standard container format for audio/video"
  homepage "https://www.matroska.org/"
  url "https://dl.matroska.org/downloads/libmatroska/libmatroska-1.4.4.tar.bz2"
  mirror "https://www.bunkus.org/videotools/mkvtoolnix/sources/libmatroska-1.4.4.tar.bz2"
  sha256 "d3efaa9f6d3964351a05bea0f848a8d5dc570e4791f179816ce9a93730296bd7"

  bottle do
    cellar :any
    revision 1
    sha256 "e7e5ba09a40fea9dbc174c751c9c03e0feb6f4d2ae706b331a2f2b0bfec7d2b8" => :el_capitan
    sha256 "ec806b9b2be99dc2588133417d230458ec721fe6a26d3aa65640e45bdfd6ad74" => :yosemite
    sha256 "86d34a8a5c9dd1944785961f6f54553b7a01ce50e1ab51c6d806fec8a3144a43" => :mavericks
  end

  head do
    url "https://github.com/Matroska-Org/libmatroska.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option :cxx11

  if build.cxx11?
    depends_on "libebml" => "c++11"
  else
    depends_on "libebml"
  end

  depends_on "pkg-config" => :build

  def install
    ENV.cxx11 if build.cxx11?

    system "autoreconf", "-fi" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
