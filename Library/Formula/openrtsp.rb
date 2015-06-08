require 'formula'

class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage 'http://www.live555.com/openRTSP'
  url 'http://www.live555.com/liveMedia/public/live.2014.10.21.tar.gz'
  sha1 'e493e0d6f7f2bf4be8e88393bb3ba583136bb271'

  bottle do
    cellar :any
    sha1 "01a5a2676e3995e505fc092ca949b67691f2e812" => :yosemite
    sha1 "f019de571028a7fa0027a2f4e464651e5a5259f9" => :mavericks
    sha1 "ee10c6dd74631ae656f4482380a1ec81c86e779d" => :mountain_lion
  end

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
