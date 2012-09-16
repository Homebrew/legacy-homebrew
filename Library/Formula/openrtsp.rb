require 'formula'

class Openrtsp < Formula
  homepage 'http://www.live555.com/openRTSP'
  url 'http://www.live555.com/liveMedia/public/live.2012.09.12.tar.gz'
  sha1 '0eefb93bee7a292ed85095480e69d756d03acd54'

  option "32-bit"

  def install
    if build.build_32_bit? || !MacOS.prefer_64_bit?
      system "./genMakefiles macosx-32bit"
    else
      system "./genMakefiles macosx"
    end

    system "make"

    cd 'testProgs' do
      bin.install 'openRTSP' ,'vobStreamer', 'playSIP'
    end
  end
end
