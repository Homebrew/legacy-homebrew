require 'formula'

class Unar < Formula
  homepage 'http://unarchiver.c3.cx/commandline'
  url 'http://theunarchiver.googlecode.com/files/unar1.3_src.zip'
  version '1.3'
  sha1 '1124d41332f37c34cd815b889d3c6945175cf87e'
  head 'https://code.google.com/p/theunarchiver/' , :using => :hg

  depends_on :xcode

  def install
    if not  build.include? "HEAD"
      #The folders are moved into a folder called The Unarchiver
      #We must move them to a higher level
      #When the source is dowloaded from hg there is no problem
      move "./The Unarchiver/License.txt", "./License.txt"
      move "./The Unarchiver/Extra" , "./Extra"
      move "./The Unarchiver/UniversalDetector" ,"./UniversalDetector"
      move "./The Unarchiver/XADMaster" ,"./XADMaster"
    end
    #Build dependencies:
    system "xcodebuild -project ./UniversalDetector/UniversalDetector.xcodeproj -target libUniversalDetector.a SYMROOT=../"
    system "xcodebuild -project ./XADMaster/XADMaster.xcodeproj -target libXADMaster.a SYMROOT=../"
    move "./Release/libUniversalDetector.a",  "./Debug/libUniversalDetector.a"
    #Build unar and lsar
    system "xcodebuild -project ./XADMaster/XADMaster.xcodeproj -target unar SYMROOT=../"
    system "xcodebuild -project ./XADMaster/XADMaster.xcodeproj -target lsar SYMROOT=../"
    bin.install "./Debug/unar", "./Debug/lsar"
    #Copy man pages
    man1.install "./Extra/lsar.1", "./Extra/unar.1"
  end
end
