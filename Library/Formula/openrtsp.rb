require 'formula'

class Openrtsp < Formula
  homepage 'http://www.live555.com/openRTSP'
  url 'http://www.live555.com/liveMedia/public/live.2014.01.07.tar.gz'
  sha1 '09fcf815a448d0ba27cff367099a241adde97a33'

  option "32-bit"

  def install
    if build.build_32_bit? || !MacOS.prefer_64_bit?
      ENV.m32
      system "./genMakefiles macosx-32bit"
    else
      system "./genMakefiles macosx"
    end

    system "make", "PREFIX=#{prefix}", "install"
  end
end
