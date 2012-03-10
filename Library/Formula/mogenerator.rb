require 'formula'

class Mogenerator < Formula
  url 'https://github.com/rentzsch/mogenerator/tarball/1.25'
  homepage 'http://rentzsch.github.com/mogenerator/'
  md5 '008f4cc1a96a1ad5acad87cbe4f47e95'
  head "https://github.com/rentzsch/mogenerator.git"

  def install
    system "xcodebuild -target mogenerator -configuration Release SYMROOT=symroot OBJROOT=objroot"
    bin.install "symroot/Release/mogenerator"

    # Install default demplates
    (prefix+'templates').install Dir['templates/*.motemplate']
  end

  def caveats; <<-EOS.undent
     A default set of Mogenerator templates have been installed to:
       #{prefix}/templates

     If you haven't written your own templates, you may wish to copy these for
     your own use:

       mkdir -p "#{ENV['HOME']}/Library/Application Support/mogenerator"
       cp #{prefix}/templates/*.motemplate "#{ENV['HOME']}/Library/Application Support/mogenerator/"

    EOS
  end
end
