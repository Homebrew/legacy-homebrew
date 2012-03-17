require 'formula'

class Trang < Formula
  homepage 'http://code.google.com/p/jing-trang/'
  url 'http://jing-trang.googlecode.com/files/trang-20091111.zip'
  md5 '9d31799b948c350850eb9dd14e5b832d'

  def install
    libexec.install Dir["*"]
    (bin+'trang').write <<-EOS.undent
      #!/bin/bash
      java -jar "#{libexec}/trang.jar" "$@"
    EOS
  end
end
