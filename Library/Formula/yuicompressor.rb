require 'formula'

class Yuicompressor < Formula
  homepage 'http://yuilibrary.com/projects/yuicompressor'
  url 'http://yui.zenfs.com/releases/yuicompressor/yuicompressor-2.4.7.zip'
  md5 '885657c68ed617737e730b4c2ce52dda'

  def install
    libexec.install "build/yuicompressor-#{version}.jar"
    (bin+'yuicompressor').write <<-EOS.undent
      #!/bin/sh
      java -jar "#{libexec}/yuicompressor-#{version}.jar" "$@"
    EOS
  end
end
