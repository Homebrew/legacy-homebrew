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

  def caveats
      <<-EOS.undent
      Game_Music_Emu is a collection of video game music file emulators that 
      support the following formats and systems: 
        AY        ZX Spectrum/Amstrad CPC
        GBS       Nintendo Game Boy
        GYM       Sega Genesis/Mega Drive
        HES       NEC TurboGrafx-16/PC Engine
        KSS       MSX Home Computer/other Z80 systems (doesn't support FM sound)
        NSF/NSFE  Nintendo NES/Famicom (with VRC 6, Namco 106, and FME-7 sound)
        SAP       Atari systems using POKEY sound chip
        SPC       Super Nintendo/Super Famicom
        VGM/VGZ   Sega Master System/Mark III, Sega Genesis/Mega Drive,BBC Micro
    EOS
  end
end
