require 'formula'

class Adium < Formula
  url 'http://download.adium.im/adium-1.4.1.tgz'
  homepage 'http://adium.im'
  md5 'ef134de0b7396524e51f35cc14de2807'

  def install
    system "make clean adium"

    prefix.install Dir['build/Release-Debug/Adium.app']
    ohai "Add Adium's link to your /Applications:\n sudo ln -s #{prefix}/Adium.app /Applications"
  end

  def caveats; <<-EOS.undent
      Adium.app installed to:
        #{prefix}

      To link the application to a normal Mac OS X location:
          brew linkapps
      or:
          sudo ln -s #{prefix}/Adium.app /Applications
      EOS
  end
end