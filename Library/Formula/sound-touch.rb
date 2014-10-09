require "formula"

class SoundTouch < Formula
  homepage "http://www.surina.net/soundtouch/"
  url "http://www.surina.net/soundtouch/soundtouch-1.8.0.tar.gz"
  sha256 "3d4161d74ca25c5a98c69dbb8ea10fd2be409ba1a3a0bf81db407c4c261f166b"

  option "with-integer-samples", "Build using integer samples? (default is float)"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "/bin/sh", "bootstrap"
    args = ["--disable-dependency-tracking",
            "--disable-silent-rules",
            "--prefix=#{prefix}"]
    args << "--enable-integer-samples" if build.with? "integer-samples"

    system "./configure",*args
    system "make", "install"
  end
end
