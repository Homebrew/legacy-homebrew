require 'formula'

class AndroidSdk < Formula
  url 'http://dl.google.com/android/android-sdk_r18-macosx.zip'
  homepage 'http://developer.android.com/index.html'
  md5 '8328e8a5531c9d6f6f1a0261cb97af36'
  version 'r18'

  def self.var_dirs
    %w[platforms samples temp add-ons sources system-images extras]
    # TODO docs and platform-tools
    # See the long comment below for the associated problems
  end

  skip_clean var_dirs

  def install
    mkdir bin

    mv 'SDK Readme.txt', prefix/'README'
    mv 'tools', prefix

    %w[android apkbuilder ddms dmtracedump draw9patch etc1tool emulator
    hierarchyviewer hprof-conv lint mksdcard monkeyrunner traceview
    zipalign].each do |tool|
      (bin/tool).write <<-EOS.undent
        #!/bin/sh
        TOOL="#{prefix}/tools/#{tool}"
        exec "$TOOL" "$@"
      EOS
    end

    # this is data that should be preserved across upgrades, but the Android
    # SDK isn't too smart, so we still have to symlink it back into its tree.
    AndroidSdk.var_dirs.each do |d|
      dst = prefix/d
      src = var/'lib/android-sdk'/d
      src.mkpath unless src.directory?
      dst.make_relative_symlink src
    end

    (bin+'adb').write <<-EOS.undent
      #!/bin/sh
      ADB="#{prefix}/platform-tools/adb"
      test -f "$ADB" && exec "$ADB" "$@"
      echo Use the \\`android\\' tool to install the \\"Android SDK Platform-tools\\".
      EOS
  end

  def caveats; <<-EOS.undent
    Now run the `android' tool to install the actual SDK stuff.

    NOTE you should tell Eclipse, IntelliJ etc. to use the Android-SDK found
    here: #{prefix}

    You will have to install the platform-tools and docs EVERY time this formula
    updates. If you want to try and fix this then see the comment in this formula.

    You may need to add the following to your .bashrc:

       export ANDROID_SDK_ROOT=#{prefix}
    EOS
  end

  # The `android' tool insists on deleting #{prefix}/platform-tools
  # and then installing the new one. So it is impossible for us to redirect
  # the SDK location to var so that the platform-tools don't have to be
  # freshly installed EVERY DANG time the base SDK updates.

  # Ideas: make android a script that calls the actual android tool, but after
  # that tool exits it repairs the directory locations?
end
