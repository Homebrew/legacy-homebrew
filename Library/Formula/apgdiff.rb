require 'formula'

class Apgdiff < Formula
  homepage 'http://apgdiff.startnet.biz/index.php'
  url 'http://apgdiff.startnet.biz/download/apgdiff-2.3-bin.zip'
  mirror 'http://downloads.sourceforge.net/project/apgdiff/apgdiff/apgdiff-2.3/apgdiff-2.3-bin.zip'
  sha1 '6d42dd3b2496dec0063de3070ad7306a1588e266'

  def install
    libexec.install "apgdiff-#{version}.jar"
    prefix.install 'changelog.txt' => 'ChangeLog'
    prefix.install 'license.txt' => 'LICENSE'
    (bin+'apgdiff').write <<-EOS.undent
      #!/bin/bash
      java -jar "#{libexec}/apgdiff-#{version}.jar" "$@"
    EOS
  end
end
