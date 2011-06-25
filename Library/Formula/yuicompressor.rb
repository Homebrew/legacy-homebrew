require 'formula'

class Yuicompressor < Formula
  url 'http://yui.zenfs.com/releases/yuicompressor/yuicompressor-2.4.6.zip'
  homepage 'http://yuilibrary.com/projects/yuicompressor'
  md5 '85670711b55124240a087e0b552304fa'

  def install
    libexec.install "build/yuicompressor-2.4.6.jar"
    (bin+'yuicompressor').write <<-EOS.undent
      #!/bin/sh
      java -jar "#{libexec}/yuicompressor-2.4.6.jar" $@
    EOS
  end
end
