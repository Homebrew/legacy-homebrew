require 'formula'

class Gnat < Formula
  homepage 'http://libre.adacore.com/tools/gnat-gpl-edition/'
  url 'http://mirrors.cdn.adacore.com/art-bundle?prefix=x86_64-darwin%2F2012%2F&f=729192a1ebe222e3e21a189c04ac23e4bd58fbe0&format=tar'
  version '2012'
  sha1 '69a8a4a01bc394c628e799225f07f04d9b017f88'

  def install
    system 'tar zxf 2012/gnatgpl/gnat-gpl-2012-x86_64-apple-darwin10.8.0-bin.tar.gz'
    system "make -C gnat-2012-x86_64-apple-darwin10.8.0-bin ins-all prefix=#{prefix}"
  end
  
  def caveats; <<-EOS.undent
    Includes:
    - GNAT GPL Edition
    - GNAT Programming Studio
    
    To prevent the custom gcc version to mess up with MacOS included one:
    
        export PATH="/usr/local/bin:$PATH"
    
    EOS
  end

  def test
    system 'gnatmake --version'
  end
end
