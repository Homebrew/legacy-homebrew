require 'formula'

class DwarfFortress < Formula
  url 'http://www.bay12games.com/dwarves/df_31_25_osx.tar.bz2'
  homepage 'http://www.bay12games.com/dwarves/'
  md5 '673b098b8b9c07b4c6be507dba8c7657'
  version '0.31.25'

  def script; <<-EOS.undent
    #!/bin/sh
    # Dwarf Fortress wrapper script
    exec #{prefix}/df
    EOS
  end

  def install
    # Fixes: http://www.bay12games.com/dwarves/mantisbt/view.php?id=4103#c18417
    inreplace 'df', 'DYLD_FALLBACK_', 'DYLD_' if MacOS.lion?

    (bin + 'dwarffortress').write script

    rm_rf 'sdl' # only contains a readme

    prefix.install Dir['*']
  end
end
