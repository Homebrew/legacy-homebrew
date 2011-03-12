require 'formula'

class Yuicompressor <Formula
  url 'http://yuilibrary.com/downloads/yuicompressor/yuicompressor-2.4.2.zip'
  homepage 'http://yuilibrary.com/projects/yuicompressor'
  md5 '2a526a9aedfe2affceed1e1c3f9c0579'

  def install
    libexec.install "build/yuicompressor-2.4.2.jar"
    (bin+'yuicompressor').write <<-EOS.undent
      #!/bin/sh
      java -jar "#{libexec}/yuicompressor-2.4.2.jar" $@
    EOS
  end
end
