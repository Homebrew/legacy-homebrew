require 'formula'

class DwarfFortress < Formula
  url 'http://www.bay12games.com/dwarves/df_34_05_osx.tar.bz2'
  homepage 'http://www.bay12games.com/dwarves/'
  md5 '470dd5b1f75bdc2f567a10127b3708bf'
  version '0.34.05'

  def script; <<-EOS.undent
    #!/bin/sh
    # Dwarf Fortress wrapper script
    exec #{prefix}/df
    EOS
  end

  def install
    (bin + 'dwarffortress').write script

    rm_rf 'sdl' # only contains a readme

    prefix.install Dir['*']
  end
end
