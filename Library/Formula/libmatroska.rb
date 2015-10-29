class Libmatroska < Formula
  desc "Extensible, open standard container format for audio/video"
  homepage "http://www.matroska.org/"

  stable do
    url "http://dl.matroska.org/downloads/libmatroska/libmatroska-1.4.4.tar.bz2"
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
    sha256 "a4526f7956bd9d6672fce68bfa466fee82fe3e7d09c8e4a90646d01a5dde9507" => :el_capitan
    sha1 "d053e9fa24d4cf44df2fed66135229c93730fadc" => :yosemite
    sha1 "9e6ed0b827540637402c1486392caab57a643724" => :mavericks
    sha1 "b364a51830e23a3ab15fc65ecaa04e40853073b3" => :mountain_lion
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
