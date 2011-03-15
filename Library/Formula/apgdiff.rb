require 'formula'

class Apgdiff < Formula
  url 'http://downloads.sourceforge.net/project/apgdiff/apgdiff/apgdiff-1.4/apgdiff-1.4-bin.zip'
  homepage 'http://apgdiff.sourceforge.net/'
  md5 '6ef287d02b4429d2111140f7fb2d8c29'

  def startup_script
<<-EOS
#!/bin/bash
java -jar "#{libexec}/apgdiff-1.4.jar" "$@"
EOS
  end

  def install
    libexec.install "apgdiff-1.4.jar"
    (bin+'apgdiff').write startup_script
  end
end
