require 'formula'

class Mpg123 < Formula
  homepage 'http://www.mpg123.de/'
  url 'http://sourceforge.net/projects/mpg123/files/mpg123/1.15.3/mpg123-1.15.3.tar.bz2'
  mirror 'http://mpg123.orgis.org/download/mpg123-1.15.3.tar.bz2'
  sha1 '915eb8782106a62b103a1171364571d69cb64e25'

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
