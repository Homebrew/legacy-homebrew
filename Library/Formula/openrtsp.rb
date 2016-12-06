require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Openrtsp < Formula
  homepage 'http://www.live555.com/openRTSP'
  url 'http://www.live555.com/liveMedia/public/live.2012.07.03.tar.gz'
  version '2012.07.03'
  sha1 '327b0e419f9fb8881720450531a3d05b291648dc'

  def options
    [
      ['--32-bit', 'Build 32-bit only.']
    ]
  end

  def install
    if ARGV.build_32_bit? || !MacOS.prefer_64_bit?
      system "./genMakefiles macosx-32bit"
    else
      system "./genMakefiles macosx"
    end

    system "make"

    cd 'testProgs' do
      bin.install 'openRTSP'
      bin.install 'vobStreamer'
      bin.install 'playSIP'
    end
  end

  def caveats
    if MacOS.prefer_64_bit? then
      s = <<-EOS

To install openRTSP in 32-bit mode:
   brew install openrtsp --32-bit

      EOS
    end
  end
end
