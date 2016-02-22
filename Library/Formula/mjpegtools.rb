class Mjpegtools < Formula
  desc "Record and playback videos and perform simple edits"
  homepage "http://mjpeg.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mjpeg/mjpegtools/2.1.0/mjpegtools-2.1.0.tar.gz"
  sha256 "864f143d7686377f8ab94d91283c696ebd906bf256b2eacc7e9fb4dddcedc407"
  revision 1

  bottle do
    cellar :any
    sha256 "58c10848fd5d1f9bd95c5ca5e046a1e68e1162ebe382b79b5f93e625c4c2855e" => :el_capitan
    sha256 "f96946c117b2d08b387b57e58c9642968c74a1c061ceb651fa92de6e63f8cb46" => :yosemite
    sha256 "3477b7df54eaef29d1502fb505eb5f55b2da05ab40cb529460d10523a1b5ab93" => :mavericks
  end

  depends_on :x11 => :optional

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libquicktime" => :optional
  depends_on "libdv" => :optional
  depends_on "gtk+" => :optional
  depends_on "sdl_gfx" => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--enable-simd-accel",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
