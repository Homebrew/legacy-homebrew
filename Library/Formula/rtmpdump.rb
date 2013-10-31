require 'formula'

# Use a newer version instead of the upstream tarball:
# http://livestreamer.tanuki.se/en/latest/issues.html#installed-rtmpdump-does-not-support-jtv-argument
class Rtmpdump < Formula
  homepage 'http://rtmpdump.mplayerhq.hu'
  url 'http://ftp.de.debian.org/debian/pool/main/r/rtmpdump/rtmpdump_2.4+20121230.gitdf6c518.orig.tar.gz'
  version '2.4+20121230'
  sha1 'a58e8a9c9f99f721389215dd16162a698734f03b'

  head 'git://git.ffmpeg.org/rtmpdump'

  depends_on 'openssl' if MacOS.version <= :leopard

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
