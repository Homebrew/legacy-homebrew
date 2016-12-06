require 'formula'

class Appledoc < Formula
  url 'https://github.com/tomaz/appledoc/tarball/v2.0.4'
  md5 'a0f3497d0939c72bd1202b659e812ae0'
  head 'git://github.com/tomaz/appledoc.git', :using => :git
  homepage 'http://www.gentlebytes.com/home/appledocapp/'

  def install
    ENV['CC'] = "#{MacOS.xcode_prefix}/usr/bin/clang"
    system "xcodebuild", "-project", "appledoc.xcodeproj", "-target", "appledoc", "-configuration", "Release", "SYMROOT=symroot", "OBJROOT=objroot"
    bin.install "symroot/Release/appledoc"

    (prefix + 'Templates').install Dir['Templates/*']
  end

 def caveats; <<-EOS.undent
   A default set of Appledoc templates have been installed to:

   #{prefix}/templates

   To use appledoc, you need to link these templates into either
     ~/.appledoc
   or to
     ~/Library/Application Support/appledoc

   For example:
     ln -s #{prefix}/Templates ~/Library/Application\\ Support/appledoc

        EOS
  end
end
