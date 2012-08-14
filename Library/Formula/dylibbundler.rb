require 'formula'

# small command-line programs that aims to make bundling .dylibs as easy as possible.
class Dylibbundler < Formula
  homepage 'http://macdylibbundler.sourceforge.net'
  url 'http://sourceforge.net/projects/macdylibbundler/files/macdylibbundler/0.4.1/dylibbundler0.4.1.zip'
  sha1 'ea80b57a487da3df3e3cc508573bf18268100464'

  def install
    system "make"
    bin.install "dylibbundler"
  end

  def test
    system "dylibbundler", "-h"
  end

  def caveats; <<-EOS.undent
    dylibbundler comes with no man page!

    Pease check documentation at #{homepage}

    Usage example:

      dylibbundler -od -b -x ./HelloWorld.app/Contents/MacOS/helloworld \\
        -d ./HelloWorld.app/Contents/libs/    
    EOS
  end
end
