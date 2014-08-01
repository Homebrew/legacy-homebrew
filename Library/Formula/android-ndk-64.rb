require 'formula'

class AndroidNdk64 < Formula
  homepage 'http://developer.android.com/sdk/ndk/index.html'
  version 'r10'

  if MacOS.prefer_64_bit?
    url "http://dl.google.com/android/ndk/android-ndk64-r10-darwin-x86_64.tar.bz2"
    sha1 '9ecda655e448d3b249be17f1d66f7e4f9535a3b8'
  else
    url " http://dl.google.com/android/ndk/android-ndk64-r10-darwin-x86.tar.bz2"
    sha1 '0fbfd9b3af17cdab56ac475e1998f53c31fb9c1d'
  end

  depends_on 'android-sdk'

  def install
    bin.mkpath
    prefix.install Dir['*']

    # Create a dummy script to launch the ndk apps
    ndk_exec = prefix+'ndk-exec.sh'
    ndk_exec.write <<-EOS.undent
      #!/bin/sh
      BASENAME=`basename $0`
      EXEC="#{prefix}/$BASENAME"
      test -f "$EXEC" && exec "$EXEC" "$@"
    EOS
    ndk_exec.chmod 0755
    %w[ndk-build64 ndk-gdb64 ndk-stack64].each { |app| bin.install_symlink ndk_exec => app }
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
