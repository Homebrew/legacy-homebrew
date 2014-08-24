require 'formula'

# Use a newer version instead of the upstream tarball:
# http://livestreamer.tanuki.se/en/latest/issues.html#installed-rtmpdump-does-not-support-jtv-argument
class Rtmpdump < Formula
  homepage 'http://rtmpdump.mplayerhq.hu'
  url 'http://ftp.de.debian.org/debian/pool/main/r/rtmpdump/rtmpdump_2.4+20131018.git79459a2.orig.tar.gz'
  version '2.4+20131018'
  sha1 '17decff9d16bbcf45f622ca8ee2400c46c277500'
  revision 1

  bottle do
    cellar :any
    sha1 "29ea9f093cbed2342eec3486382335ae2908df22" => :mavericks
    sha1 "02666b18d700e6d469186c26e416316a8bd7560b" => :mountain_lion
    sha1 "d6803f6c6ab24b45dc4e0626c7c8f5eaef9df034" => :lion
  end

  head "git://git.ffmpeg.org/rtmpdump"

  depends_on 'openssl'

  fails_with :llvm do
    build 2336
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
                   "sbindir=#{bin}",
                   "install"
  end
end
