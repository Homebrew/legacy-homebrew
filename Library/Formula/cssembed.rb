require 'formula'

class Cssembed < Formula
  url 'https://github.com/downloads/nzakas/cssembed/cssembed-0.4.0.jar'
  homepage 'http://www.nczonline.net/blog/2009/11/03/automatic-data-uri-embedding-in-css-files/'
  md5 '621ef90db822ee3cdfa09aac8a8cebb3'

  def install
    libexec.install "cssembed-0.4.0.jar"
    (bin+'cssembed').write <<-EOS.undent
      #!/bin/sh
      java -jar "#{libexec}/cssembed-0.4.0.jar" $@
    EOS
  end
end
