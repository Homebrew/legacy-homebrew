require 'formula'

class AndroidSdk <Formula
  url 'http://dl.google.com/android/android-sdk_r10-mac_x86.zip'
  homepage 'http://developer.android.com/index.html'
  md5 'e3aa5578a6553b69cc36659c9505be3f'
  version 'r10'

  def self.var_dirs
    %w[platforms samples temp add-ons ]
    # TODO docs, google-market_licensing and platform-tools
    # See the long comment below for the associated problems
  end

  skip_clean var_dirs

  def install
    mkdir bin

    mv 'SDK Readme.txt', prefix/'README'
    mv 'tools', prefix

    %w[android apkbuilder ddms dmtracedump draw9patch emulator
           hierarchyviewer hprof-conv layoutopt mksdcard traceview
           zipalign].each do |tool|
      (bin/tool).make_link(prefix/'tools'/tool)
    end

    # this is data that should be preserved across upgrades, but the Android
    # SDK isn't too smart, so we still have to symlink it back into its tree.
    AndroidSdk.var_dirs.each do |d|
      dst = prefix/d
      src = var/'lib/android-sdk'/d
      src.mkpath unless src.directory?
      dst.make_relative_symlink src
    end

    (bin/:adb).write <<-EOS.undent
      #!/bin/sh
      ADB="#{prefix}/platform-tools/adb"
      test -f "$ADB" && exec "$ADB" "$@"
      echo Use the \\`android\\' tool to install adb.
      EOS
  end

  def caveats; <<-EOS.undent
    Now run the `android' tool to install the actual SDK stuff.
    You will have to install the platform-tools EVERY time this formula updates.
    If you want to try and fix this then see the comment in this formula.
    EOS
  end

  # The `android' tool insists on deleting /usr/local/Cellar/android-sdl/rx/platform-tools
  # and then installing the new one. So it is impossible for us to redirect
  # the SDK location to var so that the platform-tools don't have to be
  # freshly installed EVERY FUCKING time the base SDK updates.
  # My disgust at Google's ineptitude here knows NO bounds. I can only LOL.
  # And I do LOL. A lot. In Google's general direction. I can't stop LOLing.
  # In fact, I may have LOLd myself into insanity.

  # Ideas: make android a script that calls the actual android tool, but after
  # that tool exits it repairs the directory locations?
end
