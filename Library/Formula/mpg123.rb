require 'formula'

class Mpg123 < Formula
  homepage 'http://www.mpg123.de/'
  url 'http://downloads.sourceforge.net/project/mpg123/mpg123/1.14.2/mpg123-1.14.2.tar.bz2'
  mirror 'http://www.mpg123.de/download/mpg123-1.14.2.tar.bz2'
  sha1 '887a453e49e3d49d539a712ee66a8d9da16e3325'

  def install
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            '--with-default-audio=coreaudio',
            '--with-module-suffix=.so']

    if MacOS.prefer_64_bit?
      args << "--with-cpu=x86-64"
    else
      args << "--with-cpu=sse_alone"
    end

    system "./configure", *args
    system "make install"
  end
end
