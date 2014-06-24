require "formula"

class Surfraw < Formula
    url "http://surfraw.alioth.debian.org/dist/surfraw-2.2.9.tar.gz"
    head 'git://git.debian.org/surfraw/surfraw.git'
    homepage 'http://surfraw.alioth.debian.org/'
    sha1 "70bbba44ffc3b1bf7c7c4e0e9f0bdd656698a1c0"

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
