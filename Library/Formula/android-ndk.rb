require 'formula'

class AndroidNdk < Formula
  url 'http://dl.google.com/android/ndk/android-ndk-r5b-darwin-x86.tar.bz2'
  homepage 'http://developer.android.com/sdk/ndk/index.html#overview'
  md5 '019a14622a377b3727ec789af6707037'
  version 'r5b'

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
