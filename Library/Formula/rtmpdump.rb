# Use a newer version instead of the upstream tarball:
# http://livestreamer.tanuki.se/en/latest/issues.html#installed-rtmpdump-does-not-support-jtv-argument
class Rtmpdump < Formula
  desc "Tool for downloading RTMP streaming media"
  homepage "https://rtmpdump.mplayerhq.hu"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/r/rtmpdump/rtmpdump_2.4+20150115.gita107cef.orig.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/r/rtmpdump/rtmpdump_2.4%2b20150115.gita107cef.orig.tar.gz"
  version "2.4+20150115"
  sha256 "d47ef3a07815079bf73eb5d053001c4341407fcbebf39f34e6213c4b772cb29a"

  head "git://git.ffmpeg.org/rtmpdump"

  bottle do
    cellar :any
    sha256 "938bc686e564cc8a82d3d30edb685729bb8b12fb8d2e7f5bee37873e17a77e96" => :el_capitan
    sha256 "5333be3b341a79c84d1bc9c2bb74ef71e2e6c49e5e2a94dd02e2ef5721acd5f5" => :yosemite
    sha256 "f906ce07d4ab1e365f22afabfa594fffba1caf0d3e7fa749a76b07a944891aba" => :mavericks
    sha256 "90f87f1c3e8c68385576812bdfadc39152d3bd9166cafb982761d1a6cc915710" => :mountain_lion
  end

  depends_on "openssl"

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
