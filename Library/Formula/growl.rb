require 'formula'

class ISO8601ParserUnparser < Formula
  url 'https://bitbucket.org/boredzo/iso-8601-parser-unparser/downloads/ISO-8601-parser-0.6.zip'
  head 'https://bitbucket.org/boredzo/iso-8601-parser-unparser', :using => :hg
  homepage 'http://boredzo.org/iso8601dateformatter/'
  sha1 '3f1228d71f3375c038805850ee468688d65d49a4'
  version '0.6'
end

class Growl < Formula
  url 'http://growl.info/hg/growl/archive/4d49890e785a.tar.bz2'
  head 'https://code.google.com/p/growl/', :using => :hg
  homepage 'http://www.growl.info/'
  sha1 'ae9fcf34a7f666bcc608285f8ee6fe4955474060'
  version '1.3.2'
  
  depends_on 'osx/plist' => :ruby unless ARGV.include? "--disable-hardware"

  def options
    [
      ["--enable-codesign", "Enable code signature"],
      ["--disable-notify", "Don't include the growlnotify application"],
      ["--disable-hardware", "Don't include the HardwareGrowler application"],
    ]
  end

  def patches
    p = []
    # Fix case sensitivity and tarball usage
    p << "https://raw.github.com/gist/1373382/"
    p << "https://raw.github.com/gist/1374166/"

    unless ARGV.include? "--disable-hardware"
      # Fix case sensitivity in HardwareGrowler.app
      p << "https://raw.github.com/gist/1380233/"
    end

    unless ARGV.include? "--enable-codesign"
      # Disable code sign in Growl.app
      p << "https://raw.github.com/gist/1374159/"

      unless ARGV.include? "--disable-hardware"
        # Disable code sign in HardwareGrowler.app
        p << "https://raw.github.com/gist/1379714/"
      end
    end

    return p
  end

  def install
    # Include dependencies not provided by the tarball.
    unless ARGV.build_head?
      p = (Pathname.getwd+'external_dependencies'+'iso8601parser')
      p.mkpath
      ISO8601ParserUnparser.new.brew{p.install Dir['*']}
    end
    
    ohai "You need to have the developer certificate already present in Keychain" if ARGV.include? "--enable-codesign"

    buildPath = Pathname.getwd+"build"

    system "xcodebuild -configuration Release SYMROOT=#{buildPath}"
    prefix.install "build/Release/Growl.app"

    unless ARGV.include? "--disable-notify"
      system "xcodebuild -project Extras/growlnotify/growlnotify.xcodeproj -configuration Release SYMROOT=#{buildPath}"
      bin.install "build/Release/growlnotify"
      man.install "Extras/growlnotify/growlnotify.1"
    end

    unless ARGV.include? "--disable-hardware"
      # Build using the previously compiled Growl.framework
      system "xcodebuild -project Extras/HardwareGrowler/HardwareGrowler.xcodeproj -configuration Release SYMROOT=#{buildPath}"
      prefix.install "build/Release/HardwareGrowler.app"
    end
  end

  def caveats
    # Infos on code signing
    s = <<-EOS.undent
          The code needs to be signed to compile, by default the signature is disable with patches.
          It may be useful to re-enable the code sign, which can be done with "--enable-codesign".

          The easiest way to enable code signature is to add manually a self-signed certificate:

          To do so, open "Keychain Access.app";
            "Keychain Access" Menu > "Certificate Assistant" > "Create a Certificate..."

          The certificate name must be :
            3rd Party Mac Developer Application: The Growl Project, LLC
          Choose "Code Signing" as Certificate Type.


    EOS

    # Info on .app
    s += <<-EOS.undent
          Growl.app and HardwareGrowler.app are installed in:
            #{prefix}

           To link the applications to a normal Mac OS X location:
             brew linkapps
           or:
             ln -s #{prefix}/Growl.app /Applications
             ln -s #{prefix}/HardwareGrowler.app /Applications
        EOS

    return s
  end
end
