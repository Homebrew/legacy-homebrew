require 'formula'

class Trang < Formula
  url 'http://jing-trang.googlecode.com/files/trang-20091111.zip'
  homepage 'http://code.google.com/p/jing-trang/'
  md5 '9d31799b948c350850eb9dd14e5b832d'

  def convenience_script target
        <<-EOS.undent
            #!/bin/bash
            java -jar #{libexec}/trang.jar "$@"
        EOS
  end

  def install
    libexec.install Dir["*"]
    (bin+'trang').write convenience_script('trang')
  end
end
