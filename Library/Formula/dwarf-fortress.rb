require 'formula'

class DwarfFortress < Formula
  url 'http://www.bay12games.com/dwarves/df_34_02_osx.tar.bz2'
  homepage 'http://www.bay12games.com/dwarves/'
  md5 'a3ca35ec3d74f1c179db48a70be648b5'
  version '0.34.02'

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
