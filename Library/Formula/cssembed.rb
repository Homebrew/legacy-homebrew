require 'formula'

class Cssembed < Formula
  url 'https://github.com/downloads/nzakas/cssembed/cssembed-0.3.6.jar'
  homepage 'http://www.nczonline.net/blog/2009/11/03/automatic-data-uri-embedding-in-css-files/'
  md5 '6f4663bb2f019827ea8e20647b091bc3'

  def install
    libexec.install "cssembed-0.3.6.jar"
    (bin+'cssembed').write <<-EOS.undent
      #!/bin/sh
      java -jar "#{libexec}/cssembed-0.3.6.jar" $@
    EOS
  end
end
