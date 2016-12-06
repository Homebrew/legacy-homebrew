require 'formula'

class Growly < Formula
  head 'git://github.com/ryankee/growly.git'
  url 'https://github.com/downloads/ryankee/growly/growly-v0.2.0.tar.gz'
  homepage 'https://github.com/ryankee/growly'
  md5 'a3e4922d619cfeb00009dc55163f0974'
  version '0.2.0'

  depends_on 'growlnotify'

  def install
    bin.install 'growly'
  end
end
