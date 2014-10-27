require "formula"

class Mpg123 < Formula
  homepage "http://www.mpg123.de/"
  url "https://downloads.sourceforge.net/project/mpg123/mpg123/1.20.1/mpg123-1.20.1.tar.bz2"
  mirror "http://mpg123.orgis.org/download/mpg123-1.20.1.tar.bz2"
  sha1 "5d7f9c27cbf258f258cb3ad7c17ebe5cda292bce"

  bottle do
    cellar :any
    sha1 "30a095c10283c8344e89fe7014b2ab7858a49844" => :yosemite
    sha1 "38109b9978996107392423313751c9c5c31a0077" => :mavericks
    sha1 "d5dd10fcc5342bdeaf737b2e24cd5c1e70682585" => :mountain_lion
  end

  def install
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--with-default-audio=coreaudio",
            "--with-module-suffix=.so"]

    if MacOS.prefer_64_bit?
      args << "--with-cpu=x86-64"
    else
      args << "--with-cpu=sse_alone"
    end

    system "./configure", *args
    system "make install"
  end
end
