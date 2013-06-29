require 'formula'

class Surfraw < Formula
  homepage 'http://surfraw.alioth.debian.org/'
  url 'http://surfraw.alioth.debian.org/dist/surfraw-2.2.8.tar.gz'
  sha1 '3114cd6e8d64f87b84ed0eff4369bfb0b10f2eb6'

  head 'git://git.debian.org/surfraw/surfraw.git'

  def install
    system "./prebuild" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-graphical-browser=open"
    system "make"
    ENV.j1 # Install using 1 job, or fails on Mac Pro
    system "make install"
  end
end
