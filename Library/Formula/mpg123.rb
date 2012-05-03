require 'formula'

class Mpg123 < Formula
  homepage 'http://www.mpg123.de/'
  url 'http://downloads.sourceforge.net/project/mpg123/mpg123/1.14.0/mpg123-1.14.0.tar.bz2'
  mirror 'http://www.mpg123.de/download/mpg123-1.14.0.tar.bz2'
  sha1 '49a3d6791cc948336aa34914582f97ac6bb2a8ff'

  depends_on 'pkg-config' => :build

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
