require 'formula'

class DwarfFortress < Formula
  url 'http://www.bay12games.com/dwarves/df_34_01_osx.tar.bz2'
  homepage 'http://www.bay12games.com/dwarves/'
  md5 '3364e147de0bf02e375ba1e5b70c4dee'
  version '0.34.01'

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
