require 'formula'

class AndroidSdk <Formula
  url 'http://dl.google.com/android/android-sdk_r07-mac_x86.zip'
  homepage 'http://developer.android.com/index.html'
  md5 '0f330ed3ebb36786faf6dc72b8acf819'
  version 'r7'

  VAR_DIRS = %w[platforms docs samples temp add-ons]

  skip_clean VAR_DIRS

  def install
    mkdir bin

    mv 'SDK Readme.txt', prefix/'README'
    mv 'tools', prefix

    %w[adb android apkbuilder ddms dmtracedump draw9patch emulator
           hierarchyviewer hprof-conv layoutopt mksdcard traceview
           zipalign].each do |tool|
      (bin/tool).make_link(prefix/'tools'/tool)
    end

    # this is data that should be preserved across upgrades, but the Android
    # SDK isn't too smart, so we still have to symlink it back into its tree.
    VAR_DIRS.each do |d|
      dst = prefix/d
      src = var/'lib/android-sdk'/d
      src.mkpath unless src.directory?
      dst.make_relative_symlink src
    end
  end

  def caveats; <<-EOS
    We put the useful tools in the PATH. Like the `android` tool. You probably
    want to run that now.
    EOS
  end
end
