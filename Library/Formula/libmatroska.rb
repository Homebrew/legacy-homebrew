class Libmatroska < Formula
  desc "Extensible, open standard container format for audio/video"
  homepage "https://www.matroska.org/"

  stable do
    url "https://dl.matroska.org/downloads/libmatroska/libmatroska-1.4.4.tar.bz2"
    mirror "https://www.bunkus.org/videotools/mkvtoolnix/sources/libmatroska-1.4.4.tar.bz2"
    sha256 "d3efaa9f6d3964351a05bea0f848a8d5dc570e4791f179816ce9a93730296bd7"
  end

  head do
    url "https://github.com/Matroska-Org/libmatroska.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  bottle do
    cellar :any
    sha256 "23417984246dabfd997d11054364071df85b88e5a6c81cbaa21dae32c106cbb4" => :el_capitan
    sha256 "4b0fbe4e06821b9d62a5c56813769cee0705e2b646d5c623a582558a05cce5f0" => :yosemite
    sha256 "5816f0ccf1d6ef2fe4225d5750d303a7cdb059291d15bbae0f73f915d855d82d" => :mavericks
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
