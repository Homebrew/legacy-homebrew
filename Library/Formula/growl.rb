require 'formula'

class ISO8601ParserUnparser < Formula
  url 'https://bitbucket.org/boredzo/iso-8601-parser-unparser/downloads/ISO-8601-parser-0.6.zip'
  head 'https://bitbucket.org/boredzo/iso-8601-parser-unparser', :using => :hg
  homepage 'http://boredzo.org/iso8601dateformatter/'
  sha1 '3f1228d71f3375c038805850ee468688d65d49a4'
  version '0.6'
end

class Growl < Formula
  url 'http://growl.info/hg/growl/archive/59aef435cefb.tar.bz2'
  head 'https://code.google.com/p/growl/', :using => :hg
  homepage 'http://www.growl.info/'
  sha1 'b556dc4c5541be79edc9ed8acfadbddd84538c36'
  version '1.3.1'
  
  def options
    [
      ["--no-sign", "Disable code signature and avoid the need for a certificate"]
    ]
  end

  def patches
    p = []
    # Fix case sensitivity and tarball usage
    p << "https://raw.github.com/gist/1373382/"
    p << "https://raw.github.com/gist/1374166/"

    if ARGV.include? "--no-sign"
      # Disable code sign
      p << "https://raw.github.com/gist/1374159/"
    end

    return p
  end

  def install
    unless ARGV.build_head?
      p = (Pathname.getwd+'external_dependencies'+'iso8601parser')
      p.mkpath
      ISO8601ParserUnparser.new.brew{p.install Dir['*']}
    end
    
    opoo "You need to have the developer certificate already present in Keychain or to use the '--no-sign' option"

    system "xcodebuild", "-configuration", "Release"
    prefix.install "build/Release/Growl.app"
  end

  def caveats
    s = <<-EOS.undent
          The code needs to be signed to compile.
          The easiest way to get rid of this problem is to use the "--no-sign" option which removes code signature.
          A recommanded alternative would be to generate a self signed certificate:

          To do so, open "Keychain Access.app";
            "Keychain Access" Menu > "Certificate Assistant" > "Create a Certificate..."
          
          The certificate name must be :
            3rd Party Mac Developer Application: The Growl Project, LLC
          Choose "Code Signing" as Certificate Type.


    EOS

    s += <<-EOS.undent
          Growl.app is installed in:
            #{prefix}

           To link the application to a normal Mac OS X location:
             brew linkapps
           or:
             ln -s #{prefix}/Growl.app /Applications
        EOS

    return s
  end
end
