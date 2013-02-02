require 'formula'

class Rtmpdump < Formula
  homepage 'http://rtmpdump.mplayerhq.hu'
  url 'http://github.com/svnpenn/rtmpdump/archive/v2.4.tar.gz'
  sha1 '6be5d932c48b30c571288b0d45ff4055fd983adc'

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
