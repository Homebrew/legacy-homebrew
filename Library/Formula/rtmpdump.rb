# Use a newer version instead of the upstream tarball:
# http://livestreamer.tanuki.se/en/latest/issues.html#installed-rtmpdump-does-not-support-jtv-argument
class Rtmpdump < Formula
  desc "Tool for downloading RTMP streaming media"
  homepage "https://rtmpdump.mplayerhq.hu"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/r/rtmpdump/rtmpdump_2.4+20150115.gita107cef.orig.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/r/rtmpdump/rtmpdump_2.4%2b20150115.gita107cef.orig.tar.gz"
  version "2.4+20150115"
  sha256 "d47ef3a07815079bf73eb5d053001c4341407fcbebf39f34e6213c4b772cb29a"

  head "git://git.ffmpeg.org/rtmpdump", :shallow => false

  bottle do
    cellar :any
    revision 1
    sha256 "ff54a87e4bf675b5b06942c73bfba5d8aad086f164fa90bdc2c53d74198072a5" => :el_capitan
    sha256 "b6ff97c9829c5e4e49b907b0cda95586b32c2041408d97ba67a8eb3341da1425" => :yosemite
    sha256 "b6a70460afac0e3a73643af0fdc61cd332e1aa48ec1f7adee20c280e4601e0a6" => :mavericks
  end

  conflicts_with "flvstreamer", :because => "both install 'rtmpsrv', 'rtmpsuck' and 'streams' binary"

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
