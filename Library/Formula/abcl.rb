require 'formula'

class Abcl < Formula
  homepage 'http://common-lisp.net/project/armedbear/'
  url 'http://common-lisp.net/project/armedbear/releases/1.1.1/abcl-bin-1.1.1.tar.gz'
  sha1 '44cf1446ec51b24947b71aa5551bdb560a675d42'

  depends_on 'rlwrap'

  def install
    prefix.install "abcl.jar", "abcl-contrib.jar"
    (bin+"abcl").write <<-EOS.undent
      #!/bin/sh
      rlwrap java -jar "#{prefix}/abcl.jar" "$@"
    EOS
  end
end
