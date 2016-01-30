class Rtmpdump < Formula
  desc "Tool for downloading RTMP streaming media"
  homepage "https://rtmpdump.mplayerhq.hu"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/r/rtmpdump/rtmpdump_2.4+20151223.gitfa8646d.orig.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/r/rtmpdump/rtmpdump_2.4%2b20151223.gitfa8646d.orig.tar.gz"
  version "2.4+20151223"
  sha256 "f8eb8d0c8ed085c90666ba0e8fbe0e960e0cf0c2a58604fda3ed85a28f2ef5f6"

  head "git://git.ffmpeg.org/rtmpdump", :shallow => false

  bottle do
    cellar :any
    sha256 "f05e64f75ae79fcfe021be7b39112ea3aac53d8d1ca22bfaa658bbf161c84675" => :el_capitan
    sha256 "c7a1bb0f9b2f7c194533a42ade11086fcb03a8bfaf76d479ae22ca4b0d107f20" => :yosemite
    sha256 "f4c8dbdf3f8a04626a7975abf96eccd5e494a3f6a795b2035c6d418bfbe8079d" => :mavericks
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
