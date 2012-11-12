require 'formula'

class Openrtsp < Formula
  homepage 'http://www.live555.com/openRTSP'
  url 'http://www.live555.com/liveMedia/public/live.2012.10.12.tar.gz'
  sha1 '429dca050b7ee631cc7ddced81207bbaba65a7cc'

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
