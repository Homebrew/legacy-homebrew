require 'formula'

class Fuse4xKext < Formula
  homepage 'http://fuse4x.org/'
  url 'https://github.com/fuse4x/kext.git', :tag => "fuse4x_0_8_11"
  version "0.8.11"

  def install
    ENV.delete('CC')
    ENV.delete('CXX')

    system "/usr/bin/xcodebuild", "-sdk", "macosx#{MACOS_VERSION}", "-configuration", "Release", "-alltargets", "MACOSX_DEPLOYMENT_TARGET=#{MACOS_VERSION}", "SYMROOT=build"
    system "/bin/mkdir -p build/Release/fuse4x.kext/Support"
    system "/bin/cp build/Release/load_fuse4x build/Release/fuse4x.kext/Support"
    prefix.install "build/Release/fuse4x.kext"
  end

  def caveats
    <<-EOS.undent
      Install kernel extension to the system:
      sudo cp -rfX #{prefix}/fuse4x.kext /System/Library/Extensions
    EOS
  end

end
