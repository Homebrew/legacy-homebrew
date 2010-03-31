require 'formula'

class AndroidSdk <Formula
  url 'http://dl.google.com/android/android-sdk_r05-mac_86.zip'
  homepage 'http://developer.android.com/index.html'
  md5 '6fcfeed0e1c36624c926551637eb3308'
  version 'r5'

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

  def caveats; <<-EOS.undent
    We agreed to the Android SDK License Agreement for you when we downloaded the
    SDK. If this is unacceptable you should uninstall. You can read the license
    at: http://developer.android.com/sdk/terms.html

    Please add this line to your .bash_profile:

        export ANDROID_SDK_ROOT=#{prefix}
    EOS
  end
end
