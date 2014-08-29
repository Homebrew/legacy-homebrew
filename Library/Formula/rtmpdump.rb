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
    revision 1
    sha1 "1126cbfa5d39d023ccad67fb0cce175da3d2a7cf" => :mavericks
    sha1 "c2d059576e7569d84efb186efff73abb1284660c" => :mountain_lion
    sha1 "b13347d9c8733475e46d5e29201c34d388ccab17" => :lion
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
