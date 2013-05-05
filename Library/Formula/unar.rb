require 'formula'

class Unar < Formula
  homepage 'http://unarchiver.c3.cx/commandline'
  url 'http://theunarchiver.googlecode.com/files/unar1.6_src.zip'
  version '1.6'
  sha1 '1cee2ea4bd89feff4f84754858b21f3757404d7c'

  head 'https://code.google.com/p/theunarchiver/' , :using => :hg

  depends_on :xcode

  def install
    # Tarball has extra folder over hg checkout
    cd "./The Unarchiver" unless build.head?

    # Build XADMaster.framework, unar and lsar
    system "xcodebuild -project ./XADMaster/XADMaster.xcodeproj -target XADMaster SYMROOT=../ -configuration Release"
    system "xcodebuild -project ./XADMaster/XADMaster.xcodeproj -target unar SYMROOT=../ -configuration Release"
    system "xcodebuild -project ./XADMaster/XADMaster.xcodeproj -target lsar SYMROOT=../ -configuration Release"

    bin.install "./Release/unar", "./Release/lsar"

    lib.install "./Release/libXADMaster.a"
    frameworks.install "./Release/XADMaster.framework"
    (include/'libXADMaster').install_symlink Dir["#{frameworks}/XADMaster.framework/Headers/*"]

    cd "./Extra" do
      man1.install "lsar.1", "unar.1"
      bash_completion.install "unar.bash_completion", "lsar.bash_completion"
    end
  end
end
