require 'formula'

class Jing < Formula
  homepage 'http://code.google.com/p/jing-trang/'
  url 'http://jing-trang.googlecode.com/files/jing-20091111.zip'
  md5 '13eef193921409a1636377d1efbf9843'

  def wrapper target; <<-EOS.undent
    #!/bin/bash
    java -jar "#{libexec}/bin/jing.jar" "$@"
    EOS
  end

  def install
    libexec.install Dir["*"]
    (bin+'jing').write wrapper('jing')
  end
end
