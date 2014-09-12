require "formula"

class AndroidNdk < Formula
  homepage "http://developer.android.com/sdk/ndk/index.html"

  if MacOS.prefer_64_bit?
    url "https://dl.google.com/android/ndk/android-ndk32-r10b-darwin-x86_64.tar.bz2"
    sha1 "6888a670c9d9007ffba7e314e38c367b6ea67f7c"

    resource "64bit_target" do
      url "https://dl.google.com/android/ndk/android-ndk64-r10b-darwin-x86_64.tar.bz2"
      sha1 "b8354a4547cedb2901acc3dc35fd29104f6cc1bf"
    end
  else
    url "https://dl.google.com/android/ndk/android-ndk32-r10b-darwin-x86.tar.bz2"
    sha1 "ee763b15cded16d313feded1e7244ce094825574"

    resource "64bit_target" do
      url "https://dl.google.com/android/ndk/android-ndk64-r10b-darwin-x86.tar.bz2"
      sha1 "e55fecfa0189a0f94725d3208a4a1c1d4235a3ab"
    end
  end

  depends_on "android-sdk" => :recommended

  def install
    bin.mkpath

    # Unpack 64-bit target into current directory
    target = resource("64bit_target")
    target.verify_download_integrity(target.fetch)
    system "tar", "xf", target.cached_download, "-C", buildpath.dirname

    # Now we can install both 64-bit and 32-bit targeting toolchains
    prefix.install Dir["*"]

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
