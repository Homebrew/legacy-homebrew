class AndroidNdk < Formula
  desc "Android native-code language toolset"
  homepage "https://developer.android.com/sdk/ndk/index.html"
  url "https://dl.google.com/android/ndk/android-ndk-r10e-darwin-x86_64.bin"
  version "r10e"
  sha256 "728c309e606f63101f1258c9d3d579b80ac74fe74c511ebb71f460ce5c5d084e"

  bottle :unneeded

  # As of r10e, only a 64-bit version is provided
  depends_on :arch => :x86_64
  depends_on "android-sdk" => :recommended

  def install
    bin.mkpath

    chmod 0755, "./android-ndk-#{version}-darwin-x86_64.bin"
    system "./android-ndk-#{version}-darwin-x86_64.bin"

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
