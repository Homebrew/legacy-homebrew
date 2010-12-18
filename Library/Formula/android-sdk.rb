require 'formula'

class AndroidSdk <Formula
  url 'http://dl.google.com/android/android-sdk_r08-mac_86.zip'
  homepage 'http://developer.android.com/index.html'
  md5 'd2e392c4e4680cbf2dfd6dbf82b662c7'
  version 'r8'

  def self.var_dirs
    %w[platforms docs samples temp add-ons]
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
  end

  def caveats; <<-EOS.undent
    We put the useful tools in the PATH. Like the `android` tool. You probably
    want to run that now.
    EOS
  end
end
