require 'formula'

class AndroidNdk <Formula
  url 'http://dl.google.com/android/ndk/android-ndk-r3-darwin-x86.zip'
  homepage 'http://developer.android.com/index.html'
  md5 'a083ccc36aa9a3a35404861e7d51d1ae'
  version 'r3'

  depends_on 'android-sdk'

  def install
    prefix.install Dir['*']
    prefix.cd { system("./build/host-setup.sh") }
  end

  def caveats; <<-EOS
We agreed to the Android NDK License Agreement for you by downloading the NDK.
If this is unacceptable you should uninstall.

License information at:
http://developer.android.com/sdk/terms.html

Software and System requirements at:
http://developer.android.com/sdk/ndk/1.6_r1/index.html#requirements

For more documentation on Android NDK, please check:
  #{prefix}/docs
EOS
  end
end
