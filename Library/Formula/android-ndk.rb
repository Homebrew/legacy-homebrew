require 'formula'

class AndroidNdk <Formula
  url 'http://dl.google.com/android/ndk/android-ndk-r4-darwin-x86.zip'
  homepage 'http://developer.android.com/sdk/ndk/index.html#overview'
  md5 'b7d5f149fecf951c05a79b045f00419f'
  version 'r4'

  depends_on 'android-sdk'

  def install
    prefix.install Dir['*']
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
