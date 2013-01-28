require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class GameMusicEmu < Formula
  homepage 'http://code.google.com/p/game-music-emu/'
  url 'http://game-music-emu.googlecode.com/files/game-music-emu-0.5.5.tbz2'
  sha1 'c7f81b8ba825de4562078443ff42ba2cbe936924'

  head 'http://game-music-emu.googlecode.com/svn/trunk/', :using => :svn

  depends_on 'cmake' => :build

  def install
    # ENV.j1  # if your formula's build system can't parallelize

    system "cmake", ".", *std_cmake_args
    system "make"
    system "make install" # if this fails, try separate make/make install steps
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test game-music-emu`.
    system "false"
  end
end
