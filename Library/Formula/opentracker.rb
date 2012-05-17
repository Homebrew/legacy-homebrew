require 'formula'

class Libowfat < Formula
  url 'http://dl.fefe.de/libowfat-0.28.tar.bz2'
  md5 '6bbee9a86506419657d87123b7a6f2c1'
  homepage 'http://www.fefe.de/libowfat/'
end

class Opentracker < Formula
  head 'cvs://:pserver:anoncvs:@cvs.erdgeist.org:/home/cvsroot:opentracker'
  homepage 'http://erdgeist.org/arts/software/opentracker/'

  def install
    # First libowfat must be compiled and installed where opentracker is expecting it
    libowfat_include = Pathname.new(pwd) + 'libowfat'
    Libowfat.new.brew do
      system "make", "install", "INCLUDEDIR=#{libowfat_include}", "LIBDIR=#{libowfat_include}", "MAN3DIR=."
    end

    # Tell opentracker that libowfat headers are located in the same directory as itself
    ENV['PREFIX'] = '.'

    system "make", "opentracker"
    bin.install "opentracker"
  end
end
