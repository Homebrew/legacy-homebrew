require "formula"

class DownloadStrategy7z < CurlDownloadStrategy
  def stage
    safe_system '7zr', 'x', tarball_path
  end
end

class AndroidNdk < Formula
  homepage "http://developer.android.com/sdk/ndk/index.html"
  version 'r10c'

  depends_on 'p7zip' => :build

  if MacOS.prefer_64_bit?
    url "https://dl.google.com/android/ndk/android-ndk-r10c-darwin-x86_64.bin" , :using => DownloadStrategy7z
    sha1 "a136ca2ad87771422c2cfa9474196cd29ffd9bb1"
  else
    url "https://dl.google.com/android/ndk/android-ndk-r10c-darwin-x86.bin" , :using => DownloadStrategy7z
    sha1 "b083f9a1a4dd66d55ced8ea41eea6a0a91ea1ac9"
  end

  depends_on "android-sdk" => :recommended

  def install
    bin.mkpath

    prefix.install Dir["*"]

    # Create a dummy script to launch the ndk apps
    ndk_exec = prefix+"ndk-exec.sh"
    ndk_exec.write <<-EOS.undent
      #!/bin/sh
      BASENAME=`basename $0`
      EXEC="#{prefix}/android-ndk-r10c/$BASENAME"
      test -f "$EXEC" && exec "$EXEC" "$@"
    EOS
    ndk_exec.chmod 0755
    %w[ndk-build ndk-gdb ndk-stack ndk-depends ndk-which ndk-stack].each { |app| bin.install_symlink ndk_exec => app }
  end

  def caveats; <<-EOS.undent
    We agreed to the Android NDK License Agreement for you by downloading the NDK.
    If this is unacceptable you should uninstall.

    License information at:
    http://developer.android.com/sdk/terms.html

    Software and System requirements at:
    http://developer.android.com/sdk/ndk/index.html#requirements

    For more documentation on Android NDK, please check:
      #{prefix}/android-ndk-r10c/docs
    EOS
  end
end
