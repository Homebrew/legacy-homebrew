class AndroidNdk < Formula
  homepage "https://developer.android.com/sdk/ndk/index.html"

  if MacOS.prefer_64_bit?
    url "https://dl.google.com/android/ndk/android-ndk-r10d-darwin-x86_64.bin"
    sha256 "46e6d0249012d926996616709f9fdd2d4506309309c19e3ab7468f7ab04b0ddc"
  else
    url "https://dl.google.com/android/ndk/android-ndk-r10d-darwin-x86.bin"
    sha256 "f1eb62d3a256f1339978b96b05bd3d7195debbf07b2d1e8a887d2f2b468d6cc7"
  end

  version "r10d"

  depends_on "android-sdk" => :recommended

  def install
    bin.mkpath

    if MacOS.prefer_64_bit?
      chmod 0755, "./android-ndk-#{version}-darwin-x86_64.bin"
      system "./android-ndk-#{version}-darwin-x86_64.bin"
    else
      chmod 0755, "./android-ndk-#{version}-darwin-x86.bin"
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
    https://developer.android.com/sdk/terms.html

    Software and System requirements at:
    https://developer.android.com/sdk/ndk/index.html#requirements

    For more documentation on Android NDK, please check:
      #{prefix}/docs
    EOS
  end
end
