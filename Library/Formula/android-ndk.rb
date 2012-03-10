require 'formula'

class AndroidNdk < Formula
  url 'http://dl.google.com/android/ndk/android-ndk-r7-darwin-x86.tar.bz2'
  homepage 'http://developer.android.com/sdk/ndk/index.html#overview'
  md5 '817ca5675a1dd44078098e43070f19b6'
  version 'r7'

  depends_on 'android-sdk'

  def install
    bin.mkpath
    prefix.install Dir['*']

    # Create a dummy script to launch the ndk apps
    ndk_exec = prefix+'ndk-exec.sh'
    (ndk_exec).write <<-EOS.undent
      #!/bin/sh
      BASENAME=`basename $0`
      EXEC="#{prefix}/$BASENAME"
      test -f "$EXEC" && exec "$EXEC" "$@"
      EOS
    (ndk_exec).chmod 0755
    %w[ ndk-build ndk-gdb ndk-stack ].each { |app| ln_s ndk_exec, bin+app }
  end

  def caveats; <<-EOS
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
