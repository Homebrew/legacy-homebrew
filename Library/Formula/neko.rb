require 'formula'

class Neko < Formula
  homepage 'http://nekovm.org/'
  url 'http://nekovm.org/_media/neko-2.0.0-osx.tar.gz'
  sha1 '7efe2932e9f3ddb795f758d0958978a4d62d8406'

  def install
    lib.install 'libneko.dylib'
    prefix.install Dir['*']
  end
  
  def caveats; <<-EOS.undent
    You may need to setup enviroment variable NEKOPATH=#{prefix} and add it to your path.
    EOS
  end
end
