require 'formula'

# Use a newer version instead of the upstream tarball:
# http://livestreamer.tanuki.se/en/latest/issues.html#installed-rtmpdump-does-not-support-jtv-argument
class Rtmpdump < Formula
  homepage 'http://rtmpdump.mplayerhq.hu'
  url 'http://ftp.debian.org/debian/pool/main/r/rtmpdump/rtmpdump_2.4+20150115.gita107cef.orig.tar.gz'
  version '2.4+20150115'
  sha256 'd47ef3a07815079bf73eb5d053001c4341407fcbebf39f34e6213c4b772cb29a'

  bottle do
    cellar :any
    revision 2
    sha1 "3b5e1371a7d7723f8e57357b065e8fb2bfe4dbd8" => :yosemite
    sha1 "0ad29a01ac270a96df4d2e17a2ac1d3a4fb66e17" => :mavericks
    sha1 "f6c770535685b2f8a7ded4e07919a1f788e5661c" => :mountain_lion
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

  test do
    system "#{bin}/rtmpdump", "-h"
  end
end
