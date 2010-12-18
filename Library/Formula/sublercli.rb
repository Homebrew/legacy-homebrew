require 'formula'

class Sublercli <Formula
  head 'http://subler.googlecode.com/svn/trunk/'
  homepage 'http://code.google.com/p/subler/'

  def install
    ENV.llvm
    cd "SublerCLI" do
      system "xcodebuild -configuration Release ARCHS='-arch i386 -arch x86_64'"
      bin.install "build/Release/SublerCLI"
    end
  end
end
