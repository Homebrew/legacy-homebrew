require 'formula'

class Pngwriter < Formula
  url 'http://downloads.sourceforge.net/project/pngwriter/pngwriter/pngwriter-0.5.4/pngwriter-0.5.4.zip'
  homepage 'http://pngwriter.sourceforge.net/'
  md5 '7e0c20f2cce6da685b68d5e9b15b5207'

  def install
    # the zip file contains one more directory
    cd("pngwriter-0.5.4")
    # use the OSX specific makefile
    ln_sf("make.include.osx", "make.include")
    system "make PREFIX=#{prefix}"
    system "make install PREFIX=#{prefix}"
  end
end
