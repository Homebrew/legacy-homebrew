require 'formula'

class Yuicompressor < Formula
  homepage 'http://yuilibrary.com/projects/yuicompressor'
  url 'http://yui.zenfs.com/releases/yuicompressor/yuicompressor-2.4.7.zip'
  sha1 '64d209cae769cee2b89217ba226543001c59d27b'

  def install
    libexec.install "build/yuicompressor-#{version}.jar"
    bin.write_jar_script libexec/"yuicompressor-#{version}.jar", "yuicompressor"
  end
end
