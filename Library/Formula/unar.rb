require 'formula'

class Unar < Formula
  homepage 'http://unarchiver.c3.cx/commandline'
  url 'http://theunarchiver.googlecode.com/files/unar1.6_src.zip'
  version '1.6'
  sha1 '1cee2ea4bd89feff4f84754858b21f3757404d7c'
  head 'https://code.google.com/p/theunarchiver/' , :using => :hg

  depends_on :xcode

  def install
    if not  build.include? "HEAD"
      #The folders are moved into a folder called The Unarchiver
      #We must move to it
      #When the source is dowloaded from hg there is no problem
      cd "./The Unarchiver"
    end
    #Build XADMaster.framework:
    system "xcodebuild -project ./XADMaster/XADMaster.xcodeproj -target XADMaster SYMROOT=../ -configuration Release"
    #Build unar and lsar
    system "xcodebuild -project ./XADMaster/XADMaster.xcodeproj -target unar SYMROOT=../ -configuration Release"
    system "xcodebuild -project ./XADMaster/XADMaster.xcodeproj -target lsar SYMROOT=../ -configuration Release"
    bin.install "./Release/unar", "./Release/lsar"
    include.mkpath
    mkdir "#{include}/libXADMaster/"
    copy Dir["./Release/XADMaster.framework/Headers/*"], "#{include}/libXADMaster/"
    lib.install "./Release/libXADMaster.a" , "./Release/XADMaster.framework"
    cd "./Extra" do
      man1.install "lsar.1", "unar.1"
      (prefix+'etc/bash_completion.d').install "unar.bash_completion", "lsar.bash_completion"
    end
  end
end
