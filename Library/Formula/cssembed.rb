require 'formula'

class Cssembed < Formula
  url 'https://github.com/downloads/nzakas/cssembed/cssembed-0.4.5.jar'
  homepage 'http://www.nczonline.net/blog/2009/11/03/automatic-data-uri-embedding-in-css-files/'
  md5 'cb98a8d7e18213b1a6e6c88e1d43f513'

  def install
    libexec.install "cssembed-0.4.5.jar"
    (bin+'cssembed').write <<-EOS.undent
      #!/bin/sh
      java -jar "#{libexec}/cssembed-0.4.5.jar" "$@"
    EOS
  end
end
