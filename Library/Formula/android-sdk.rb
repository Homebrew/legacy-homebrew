require 'formula'

class AndroidSdk <Formula
  url 'http://dl.google.com/android/android-sdk_r04-mac_86.zip'
  homepage 'http://developer.android.com/index.html'
  md5 'b08512765aa9b0369bb9b8fecdf763e3'
  version 'r4'

  skip_clean 'add-ons'
  skip_clean 'platforms'
  skip_clean 'temp'

  aka :android

  def install
    mkdir %w[temp docs] << bin

    mv 'SDK Readme.txt', 'README'
    prefix.install Dir['*']

    %w[adb android apkbuilder ddms dmtracedump draw9patch emulator 
           hierarchyviewer hprof-conv layoutopt mksdcard traceview
           zipalign].each do |tool|
      (bin+tool).make_link(prefix+'tools'+tool)
    end
  end

  def caveats; "\
We agreed to the Android SDK License Agreement for you by downloading the SDK.
If this is unacceptable you should uninstall.
You can read the license at: http://developer.android.com/sdk/terms.html"
  end
end
