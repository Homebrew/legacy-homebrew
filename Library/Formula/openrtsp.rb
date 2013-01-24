require 'formula'

class Openrtsp < Formula
  homepage 'http://www.live555.com/openRTSP'
  url 'http://www.live555.com/liveMedia/public/live.2013.01.23.tar.gz'
  sha1 '7091dd231ca064d7ef39b492c026e67652064f0c'

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
