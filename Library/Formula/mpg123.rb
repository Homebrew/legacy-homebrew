require 'formula'

class Mpg123 < Formula
  homepage 'http://www.mpg123.de/'
  url 'https://downloads.sourceforge.net/project/mpg123/mpg123/1.19.0/mpg123-1.19.0.tar.bz2'
  mirror 'http://mpg123.orgis.org/download/mpg123-1.18.0.tar.bz2'
  sha1 '835f8ae489b41ae69fa8c76a0b1e5ee5495ef0ae'

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
