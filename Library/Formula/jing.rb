require 'formula'

class Jing < Formula
  homepage 'http://code.google.com/p/jing-trang/'
  url 'https://jing-trang.googlecode.com/files/jing-20091111.zip'
  sha1 '2e8eacf399249d226ad4f6ca1d6907ff69430118'

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/'bin/jing.jar', 'jing'
  end
end
