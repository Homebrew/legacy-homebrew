require 'formula'

def kext_prefix
  prefix + 'Library' + 'Extensions'
end

class Fuse4xKext < Formula
  homepage 'http://fuse4x.github.com'
  url 'https://github.com/fuse4x/kext/tarball/fuse4x_0_9_1'
  md5 'd9139a55157427a3f9985a8e1f79e23b'
  version "0.9.1"

  bottle do
    # Bottle provided for Lion since the Command Line Tools cannot compile
    # things that use `xcodebuild`. Actual compilation takes ~10 seconds so
    # there is no need to bottle this for earlier systems.
    sha1 '2bc7b00c52823ea7efd8e09fb340f1701801baca' => :lion
  end

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
    message = <<-EOS.undent
      In order for FUSE-based filesystems to work, the fuse4x kernel extension
      must be installed by the root user:

        sudo cp -rfX #{kext_prefix}/fuse4x.kext /Library/Extensions
        sudo chmod +s /Library/Extensions/fuse4x.kext/Support/load_fuse4x

      If upgrading from a previous version of Fuse4x, the old kernel extension
      will need to be unloaded before performing the steps listed above. First,
      check that no FUSE-based filesystems are running:

        mount -t fuse4x

      Unmount all FUSE filesystems and then unload the kernel extension:

        sudo kextunload -b org.fuse4x.kext.fuse4x

    EOS

    # In fuse4x version 0.9.0 the kext has been moved from /System to /Library to match
    # filesystem layout convention from Apple.
    # Check if the user has fuse4x kext in the old location.
    # Remove this check Q4 2012 when it become clear that everyone migrated to 0.9.0+
    if File.exists?('/System/Library/Extensions/fuse4x.kext/')
      message += <<-EOS.undent
        You have older version of fuse4x installed. Please remove it by running:

          sudo rm -rf /System/Library/Extensions/fuse4x.kext/

      EOS
    end

    return message
  end
end
