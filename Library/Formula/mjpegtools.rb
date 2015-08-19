class Mjpegtools < Formula
  desc "Record and playback videos and perform simple edits"
  homepage "http://mjpeg.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mjpeg/mjpegtools/2.1.0/mjpegtools-2.1.0.tar.gz"
  sha256 "864f143d7686377f8ab94d91283c696ebd906bf256b2eacc7e9fb4dddcedc407"

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
