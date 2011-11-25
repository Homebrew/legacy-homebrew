require 'formula'

class Jing < Formula
  url 'http://jing-trang.googlecode.com/files/jing-20091111.zip'
  homepage 'http://code.google.com/p/jing-trang/'
  md5 '13eef193921409a1636377d1efbf9843'

  def convenience_script target
        <<-EOS.undent
            #!/bin/bash
            java -jar #{libexec}/bin/jing.jar "$@"
        EOS
  end

  def install
    libexec.install Dir["*"]
    (bin+'jing').write convenience_script('jing')
  end

  def test
    system "jing"
  end
end
