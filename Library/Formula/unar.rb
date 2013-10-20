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
    sha1 '18a517d2e2e79da17567fc2457e1a398336de27b' => :mountain_lion
    sha1 '84b82f23f0a053f4d3a6ee9eb0d1edd66cc1f97c' => :lion
    sha1 'c0313a5a1c6fad5b4ba6b3ac729871bdc76839bd' => :snow_leopard
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
