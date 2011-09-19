require 'formula'

class Surfraw < Formula
  url 'http://surfraw.alioth.debian.org/dist/surfraw-2.2.8.tar.gz'
  head 'git://git.debian.org/surfraw/surfraw.git'
  homepage 'http://surfraw.alioth.debian.org/'
  md5 'e0f571f7a2d109555c26bdb40781a3f2'

  def install
    system "./prebuild" if ARGV.build_head?
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-graphical-browser=open"
    system "make"
    ENV.j1 # Install using 1 job, or fails on Mac Pro
    system "make install"
  end
end
