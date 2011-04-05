require 'formula'

class Adium < Formula
  url 'http://download.adium.im/adium-1.4.1.tgz'
  homepage 'http://adium.im'
  md5 'ef134de0b7396524e51f35cc14de2807'

  def install
    system "make clean adium"

    prefix.install Dir['build/Release-Debug/Adium.app']
    ohai "Add Adium's link to your /Applications:\n sudo ln -sF #{prefix}/Adium.app /Applications/Adium.app"
  end
end