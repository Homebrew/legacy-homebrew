require "formula"

class AutoconfArchive < Formula
  homepage "http://savannah.gnu.org/projects/autoconf-archive/"
  url "http://ftpmirror.gnu.org/autoconf-archive/autoconf-archive-2014.02.28.tar.bz2"
  mirror "http://ftp.gnu.org/gnu/autoconf-archive/autoconf-archive-2014.02.28.tar.bz2"
  sha1 "93cf72148adb86bc3221793c49bf2d73c6804af8"

  def install
    system "./configure", "--prefix=#{prefix}"
    system 'make install'
  end
end
