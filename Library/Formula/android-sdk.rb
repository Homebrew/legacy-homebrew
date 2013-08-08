require 'formula'

class AdbBashCompletion < Formula
  url 'https://raw.github.com/CyanogenMod/android_sdk/3bf0a01ef66a9b99149ba3faaf34a1362581dd01/bash_completion/adb.bash'
  sha1 '8e7dad45b8c98c359516d4a818a9090125bc6f7a'
  version 'cyanogenmod_jellybean'
end

class AndroidSdk < Formula
  homepage 'http://developer.android.com/index.html'
  url 'http://dl.google.com/android/android-sdk_r22.0.4-macosx.zip'
  version 'r22.0.4'
  sha1 '1db64b870af15901942f248214b13c5648719aaa'

  # TODO docs and platform-tools
  # See the long comment below for the associated problems
  def self.var_dirs
    %w[platforms samples temp add-ons sources system-images extras]
  end

  skip_clean var_dirs

  def install
    prefix.install 'tools', 'SDK Readme.txt' => 'README'

    %w[android apkbuilder ddms dmtracedump draw9patch etc1tool emulator
    emulator-arm emulator-x86 hierarchyviewer hprof-conv lint mksdcard
    monitor monkeyrunner traceview zipalign].each do |tool|
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

    %w[adb fastboot].each do |platform_tool|
      (bin/platform_tool).write <<-EOS.undent
        #!/bin/sh
        PLATFORM_TOOL="#{prefix}/platform-tools/#{platform_tool}"
        test -f "$PLATFORM_TOOL" && exec "$PLATFORM_TOOL" "$@"
        echo Use the \\`android\\' tool to install the \\"Android SDK Platform-tools\\".
      EOS
    end

    %w[aapt aidl dexdump dx llvm-rs-cc].each do |build_tool|
      (bin/build_tool).write <<-EOS.undent
        #!/bin/sh
        BUILD_TOOL="#{prefix}/build-tools/17.0.0/#{build_tool}"
        test -f "$BUILD_TOOL" && exec "$BUILD_TOOL" "$@"
        echo Use the \\`android\\' tool to install the \\"Android SDK Build-tools\\".
      EOS
    end

    AdbBashCompletion.new.brew do
      bash_completion.install 'adb.bash' => 'adb-completion.bash'
    end
  end

  def caveats; <<-EOS.undent
    Now run the `android' tool to install the actual SDK stuff.

    The Android-SDK location for IDEs such as Eclipse, IntelliJ etc is:
      #{prefix}

    You will have to install the platform-tools and docs EVERY time this formula
    updates. If you want to try and fix this then see the comment in this formula.

    You may need to add the following to your .bashrc:
      export ANDROID_HOME=#{opt_prefix}
    EOS
  end

  # The `android' tool insists on deleting #{prefix}/platform-tools
  # and then installing the new one. So it is impossible for us to redirect
  # the SDK location to var so that the platform-tools don't have to be
  # freshly installed EVERY DANG time the base SDK updates.

  # Ideas: make android a script that calls the actual android tool, but after
  # that tool exits it repairs the directory locations?
end
