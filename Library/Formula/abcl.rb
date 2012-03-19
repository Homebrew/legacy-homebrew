require 'formula'

class Abcl < Formula
  homepage 'http://common-lisp.net/project/armedbear/'
  url 'http://common-lisp.net/project/armedbear/releases/1.0.1/abcl-bin-1.0.1.tar.gz'
  md5 'bd95a55df30469b4f6d85af7c5ede297'

  depends_on 'rlwrap'

  def install
    prefix.install "abcl.jar", "abcl-contrib.jar"
    (bin+"abcl").write <<-EOS.undent
      #!/bin/sh
      rlwrap java -jar "#{prefix}/abcl.jar" "$@"
    EOS
  end
end
