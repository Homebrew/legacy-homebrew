require 'formula'

class Unar < Formula
  homepage 'http://unarchiver.c3.cx/commandline'
  url 'http://theunarchiver.googlecode.com/files/unar1.8.1_src.zip'
  version '1.8.1'
  sha1 'fe052cd7042651cccc7ba0e9c4d6d7dba5102fd4'

  head 'https://code.google.com/p/theunarchiver/' , :using => :hg

  depends_on :xcode

  bottle do
    cellar :any
    revision 1
    sha1 '85553d3575d0ce5687b2f0c2df912e5cd46c722c' => :mavericks
    sha1 '8f10a296637ce7a9e12d5d04b731c2d7aee80760' => :mountain_lion
    sha1 'a85d038c6a19b2d2fa51f4a774e7ebed712dc4c1' => :lion
  end

  def install
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

  def test
    system bin/'unar', '--version'
    system bin/'lsar', '--version'
  end
end
