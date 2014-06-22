require "formula"

class Mpg123 < Formula
  homepage "http://www.mpg123.de/"
  url "https://downloads.sourceforge.net/project/mpg123/mpg123/1.20.0/mpg123-1.20.0.tar.bz2"
  mirror "http://mpg123.orgis.org/download/mpg123-1.20.0.tar.bz2"
  sha1 "f8060769e60c88fa2debf6c998773880e57b31a6"

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
