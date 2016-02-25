class Libebml < Formula
  desc "Sort of a sbinary version of XML"
  homepage "https://www.matroska.org/"
  url "https://dl.matroska.org/downloads/libebml/libebml-1.3.3.tar.bz2"
  mirror "https://www.bunkus.org/videotools/mkvtoolnix/sources/libebml-1.3.3.tar.bz2"
  sha256 "35fb44daa41961f94a0ac1b8f06801e88cc9bf2ad6f562ced8ab7c1f1a875499"

  head do
    url "https://github.com/Matroska-Org/libebml.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  bottle do
    cellar :any
    sha256 "67c3beaaf7861310131d3951ec5c65426caa683f535f2f58dcb42580b624e81e" => :el_capitan
    sha256 "9ecbc5db4abae34d45784d0a18ab099516b0723429e5c90d75e3d0dcb2fafda2" => :yosemite
    sha256 "3bd2e124724170da22bfbc67c102c545487d9e6af5c514865078747de1c37dbe" => :mavericks
  end

  option :cxx11

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
