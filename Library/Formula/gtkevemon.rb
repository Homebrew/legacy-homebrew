require 'formula'

class Gtkevemon < Formula
  url 'http://gtkevemon.battleclinic.com/releases/gtkevemon-1.8-source.tar.gz'
  homepage 'http://gtkevemon.battleclinic.com/'
  md5 '6cdf6dcb228052e4928367a0f7cd6b0a'

  depends_on 'gtkmm'
  depends_on 'openssl'
  
  def install
    system "make"
    bin.install("src/gtkevemon")

    ohai "--------------------------------------------------------------------------------------------------------------"
    ohai "NOTE: Remember that you have to run 'X' before you can start gtkevemon ('X' is in Applications/Utilities/X11)."
    ohai "--------------------------------------------------------------------------------------------------------------"    
  end
end