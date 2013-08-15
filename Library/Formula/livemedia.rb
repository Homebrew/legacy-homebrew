require 'formula'

class Livemedia < Formula
  homepage 'http://www.live555.com/liveMedia/'

  # Mplayer can't link with newer versions of live, so we choose a compatible as default.
  # Also live555 doesn't provide a stable archive link, so we MUST use another source.
  url 'http://live555sourcecontrol.googlecode.com/files/live.2011.12.23.tar.gz'
  sha1 '665b7542da1f719b929d51842f39474ef340d9f6'

  head 'http://www.live555.com/liveMedia/public/live555-latest.tar.gz'

  def install
    system "./genMakefiles", "macosx"
    system "make"
    prefix.install Dir['*']
    lib.install_symlink prefix => 'live'
  end

  test do
    system "#{prefix}/testProgs/openRTSP 2>&1|grep -q startPortNum"
  end
end

