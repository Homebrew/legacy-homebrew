require 'formula'

class Yuicompressor < Formula
  homepage 'http://yuilibrary.com/projects/yuicompressor'
  url 'http://yui.zenfs.com/releases/yuicompressor/yuicompressor-2.4.7.zip'
  sha1 '64d209cae769cee2b89217ba226543001c59d27b'

  def install
    libexec.install "build/yuicompressor-#{version}.jar"
    (bin+'yuicompressor').write <<-EOS.undent
      #!/bin/sh
      java -jar "#{libexec}/yuicompressor-#{version}.jar" "$@"
    EOS
  end
end
