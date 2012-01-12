require 'formula'

class Yuicompressor < Formula
  url 'http://yui.zenfs.com/releases/yuicompressor/yuicompressor-2.4.7.zip'
  homepage 'http://yuilibrary.com/projects/yuicompressor'
  md5 '885657c68ed617737e730b4c2ce52dda'

  def install
    libexec.install "build/yuicompressor-2.4.7.jar"
    (bin+'yuicompressor').write <<-EOS.undent
      #!/bin/sh
      java -jar "#{libexec}/yuicompressor-2.4.7.jar" $@
    EOS
  end
end
