require "formula"

class AndroidNdk < Formula
  homepage "http://developer.android.com/sdk/ndk/index.html"

  if MacOS.prefer_64_bit?
    url "http://dl.google.com/android/ndk/android-ndk-r10d-darwin-x86_64.bin"
    sha1 "6b89cb0c84e2d2bd802a5b78540327c1b3c2d7b8"
  else
    url "http://dl.google.com/android/ndk/android-ndk-r10d-darwin-x86.bin"
    sha1 "fc1f9593eb9669076c25381322a1386869ac02f0"
  end

  version "r10d"

  depends_on "android-sdk" => :recommended

  def install
    bin.mkpath

    if MacOS.prefer_64_bit?
      system "chmod", "a+x", "./android-ndk-#{version}-darwin-x86_64.bin"
      system "./android-ndk-#{version}-darwin-x86_64.bin"
    else
      system "chmod", "a+x", "./android-ndk-#{version}-darwin-x86.bin"
      system "./android-ndk-#{version}-darwin-x86.bin"
    end

    # Now we can install both 64-bit and 32-bit targeting toolchains
    prefix.install Dir["android-ndk-#{version}/*"]

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
