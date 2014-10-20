require "formula"

class AndroidNdk < Formula
  homepage "http://developer.android.com/sdk/ndk/index.html"
  @@urlbase = "http://dl.google.com/android/ndk/"
  @@binname = ""

  if MacOS.prefer_64_bit?
    @@binname = "android-ndk-r10c-darwin-x86_64.bin"
    sha1 "a136ca2ad87771422c2cfa9474196cd29ffd9bb1"
  else
    @@binname = "android-ndk-r10c-darwin-x86.bin"
    sha1 "b083f9a1a4dd66d55ced8ea41eea6a0a91ea1ac9"
  end

  url @@urlbase + @@binname

  version "r10c"

  depends_on "android-sdk" => :recommended

  def install
    bin.mkpath

    system "chmod", "a+x", "./" + @@binname
    system "./" + @@binname

    # Now we can install both 64-bit and 32-bit targeting toolchains
    prefix.install Dir["android-ndk-r10c/*"]

    # Create a dummy script to launch the ndk apps
    ndk_exec = prefix+"ndk-exec.sh"
    ndk_exec.write <<-EOS.undent
      #!/bin/sh
      BASENAME=`basename $0`
      EXEC="#{prefix}/$BASENAME"
      test -f "$EXEC" && exec "$EXEC" "$@"
    EOS
    ndk_exec.chmod 0755
    %w[ndk-build ndk-gdb ndk-stack].each { |app| bin.install_symlink ndk_exec => app }
  end

  def caveats; <<-EOS.undent
    We agreed to the Android NDK License Agreement for you by downloading the NDK.
    If this is unacceptable you should uninstall.

    License information at:
    http://developer.android.com/sdk/terms.html

    Software and System requirements at:
    http://developer.android.com/sdk/ndk/index.html#requirements

    For more documentation on Android NDK, please check:
      #{prefix}/docs
    EOS
  end
end
