require "formula"

class Theora < Formula
  homepage "http://www.theora.org/"
  url "http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.bz2"
  sha1 "8dcaa8e61cd86eb1244467c0b64b9ddac04ae262"

  bottle do
    cellar :any
    sha1 "b00c3931509fdc80bb432525d0c538b958a9d6f3" => :mavericks
    sha1 "8bf02895347ba10cb031c93bc7db123d43ac4fb3" => :mountain_lion
    sha1 "be77a149c88d9f3f3619e4cd66d7ef81e4a15a7c" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "libogg"
  depends_on "libvorbis"

  def install
    cp Dir["#{Formula["libtool"].opt_share}/libtool/config/config.*"], buildpath
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-oggtest",
                          "--disable-vorbistest",
                          "--disable-examples"
    system "make", "install"
  end
end
