class Libebml < Formula
  desc "Sort of a sbinary version of XML"
  homepage "https://www.matroska.org/"
  url "https://dl.matroska.org/downloads/libebml/libebml-1.3.3.tar.bz2"
  mirror "https://www.bunkus.org/videotools/mkvtoolnix/sources/libebml-1.3.3.tar.bz2"
  sha256 "35fb44daa41961f94a0ac1b8f06801e88cc9bf2ad6f562ced8ab7c1f1a875499"

  bottle do
    cellar :any
    revision 1
    sha256 "9d18eec56b97f4b9304d1c9b92b1d3cd6e3aa6c2a844098c197c3524ec68fb82" => :el_capitan
    sha256 "2590306d51d005b74fb05256c2673b4346c875ae85c4835fd2af3ebd8077f3f5" => :yosemite
    sha256 "1a2dc78501374e502a94e9e48646e01ad08fbf28be22b2d0ea8e945608623784" => :mavericks
  end

  head do
    url "https://github.com/Matroska-Org/libebml.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
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
