require 'formula'

class Trang < Formula
  homepage 'http://code.google.com/p/jing-trang/'
  url 'http://jing-trang.googlecode.com/files/trang-20091111.zip'
  sha1 'b5f1fd4b63f347c8d0575bd1922f94316240cb29'

  def install
    libexec.install Dir["*"]
    (bin+'trang').write <<-EOS.undent
      #!/bin/bash
      java -jar "#{libexec}/trang.jar" "$@"
    EOS
  end
end
