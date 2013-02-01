require 'formula'

class Openrtsp < Formula
  homepage 'http://www.live555.com/openRTSP'
  url 'http://www.live555.com/liveMedia/public/live.2013.01.25.tar.gz'
  sha1 '5ea2868e090eb40e31a500f90f094e04c2f39e03'

  option "32-bit"

  def install
    if build.build_32_bit? || !MacOS.prefer_64_bit?
      system "./genMakefiles macosx-32bit"
    else
      system "./genMakefiles macosx"
    end

    system "make"

    cd 'testProgs' do
      bin.install 'openRTSP', 'vobStreamer', 'playSIP'
    end
  end
end
