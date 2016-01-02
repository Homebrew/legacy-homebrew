class Theora < Formula
  desc "Open video compression format"
  homepage "https://www.theora.org/"
  url "http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.bz2"
  sha256 "b6ae1ee2fa3d42ac489287d3ec34c5885730b1296f0801ae577a35193d3affbc"

  bottle do
    cellar :any
    revision 2
    sha256 "03b63a91812185120355da8292b40a2afd8377dcd8e3825eb9cbc217a3f4bc79" => :el_capitan
    sha256 "ab9dd77803ec6885cb9701859de9b1b8ff6b85cb7cef24400dec6adb4b8c6378" => :yosemite
    sha256 "58be26743e23be63aee48186bfa9cd8a982de957efb040a6ab3030aa62753977" => :mavericks
  end

  head do
    url "https://git.xiph.org/theora.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "libogg"
  depends_on "libvorbis"

  def install
    cp Dir["#{Formula["libtool"].opt_share}/libtool/*/config.{guess,sub}"], buildpath
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-oggtest",
                          "--disable-vorbistest",
                          "--disable-examples"
    system "make", "install"
  end
end
