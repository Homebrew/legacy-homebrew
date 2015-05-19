class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "http://www.mpg123.de/"
  url "http://www.mpg123.de/download/mpg123-1.22.2.tar.bz2"
  mirror "http://mpg123.orgis.org/download/mpg123-1.22.2.tar.bz2"
  sha256 "6d1e2487777114ba8a73c543f355cacfa2055646724000fc195ac9e64c843744"

  bottle do
    cellar :any
    sha256 "6beab6e2bf6bf73dd95c9cad5d2bf006009ae0901073c0f02f100a517a613b23" => :yosemite
    sha256 "7a182cdd2294116093e8d4d7cb664ae3af8bc67e95861665a451acd2f4adc998" => :mavericks
    sha256 "0ecb0fb9e8a3144a166685adc9100c53d8082351224238189634cf8615a61d4d" => :mountain_lion
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
