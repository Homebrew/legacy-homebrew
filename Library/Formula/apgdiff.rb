require 'formula'

class Apgdiff < Formula
  homepage 'http://apgdiff.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/apgdiff/apgdiff/apgdiff-1.4/apgdiff-1.4-bin.zip'
  md5 '6ef287d02b4429d2111140f7fb2d8c29'

  def install
    libexec.install "apgdiff-1.4.jar"
    (bin+'apgdiff').write <<-EOS.undent
      #!/bin/bash
      java -jar "#{libexec}/apgdiff-1.4.jar" "$@"
    EOS
  end
end
