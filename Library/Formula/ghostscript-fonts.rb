require 'formula'

class GhostscriptFonts < Formula
  homepage 'http://sourceforge.net/projects/gs-fonts/'
  url 'http://downloads.sourceforge.net/project/gs-fonts/gs-fonts/8.11%20%28base%2035%2C%20GPL%29/ghostscript-fonts-std-8.11.tar.gz'
  sha1 '2a7198e8178b2e7dba87cb5794da515200b568f5'

  def install
    
    # install fonts into homebrew's share directory
    (share+'ghostscript').install '../fonts'

  end
end 
