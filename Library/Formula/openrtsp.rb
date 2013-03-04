require 'formula'

class Openrtsp < Formula
  homepage 'http://www.live555.com/openRTSP'
  url 'http://www.live555.com/liveMedia/public/live.2013.02.27.tar.gz'
  sha1 '5b89e9d532861fb389576b1dc69e8883c455a979'

  option "32-bit"

  def fix d, x
    File.chmod 0666, d + '/Makefile.' + x
    inreplace d + '/Makefile.' + x, 'PREFIX = /usr/local', 'PREFIX = ' + prefix
  end

  def install
    %w{liveMedia groupsock UsageEnvironment BasicUsageEnvironment}.each {|d| fix d, 'head'}
    %w{testProgs mediaServer proxyServer}.each {|d| fix d, 'tail'}

    if build.build_32_bit? || !MacOS.prefer_64_bit?
      ENV.m32
      system "./genMakefiles macosx-32bit"
    else
      system "./genMakefiles macosx"
    end

    system "make"
    system 'make install'
  end
end
