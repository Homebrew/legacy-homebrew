require 'formula'

def kext_prefix
  prefix + 'Library' + 'Extensions'
end

class Fuse4xKext < Formula
  homepage 'http://fuse4x.org/'
  url 'https://github.com/fuse4x/kext.git', :tag => "fuse4x_0_8_13"
  version "0.8.13"

  def install
    ENV.delete('CC')
    ENV.delete('CXX')

    args = [
      "-sdk",
      "macosx#{MACOS_VERSION}",
      "-configuration", "Release",
      "-alltargets",
      "MACOSX_DEPLOYMENT_TARGET=#{MACOS_VERSION}",
      "SYMROOT=build",
      # Build a 32-bit kernel extension on Leopard and a fat binary for Snow
      # Leopard/Lion.
      "ARCHS=i386 #{'x86_64' if MacOS.prefer_64_bit?}", 'ONLY_ACTIVE_ARCH=NO'
    ]

    system "/usr/bin/xcodebuild", *args
    system "/bin/mkdir -p build/Release/fuse4x.kext/Support"
    system "/bin/cp build/Release/load_fuse4x build/Release/fuse4x.kext/Support"

    kext_prefix.install "build/Release/fuse4x.kext"
  end

  def caveats
    <<-EOS.undent
      In order for FUSE-based filesystems to work, the fuse4x kernel extension
      must be installed by the root user:
        sudo cp -rfX #{kext_prefix}/fuse4x.kext /System/Library/Extensions
        sudo chmod +s /System/Library/Extensions/fuse4x.kext/Support/load_fuse4x
    EOS
  end
end
