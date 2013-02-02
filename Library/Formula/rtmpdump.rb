require 'formula'

class Rtmpdump < Formula
  homepage 'http://rtmpdump.mplayerhq.hu'
  url 'http://ftp.de.debian.org/debian/pool/main/r/rtmpdump/rtmpdump_2.4+20111222.git4e06e21.orig.tar.gz'
  sha1 '16f7e7470939ce8801e7d499345fa7d8f195c636'
  version '2.4'

  head 'git://git.ffmpeg.org/rtmpdump'

  depends_on 'openssl' if MacOS.version == :leopard

  fails_with :llvm do
    build '2336'
    cause "Crashes at runtime"
  end

  def install
    ENV.deparallelize
    system "make", "CC=#{ENV.cc}",
                   "XCFLAGS=#{ENV.cflags}",
                   "XLDFLAGS=#{ENV.ldflags}",
                   "MANDIR=#{man}",
                   "SYS=darwin",
                   "prefix=#{prefix}",
                   "install"
  end
end
