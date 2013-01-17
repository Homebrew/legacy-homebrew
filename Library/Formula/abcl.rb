require 'formula'

class Abcl < Formula
  homepage 'http://common-lisp.net/project/armedbear/'
  url 'http://common-lisp.net/project/armedbear/releases/1.1.0/abcl-bin-1.1.0.tar.gz'
  sha1 '683fe0c63dc8ba2abdf365a70a7f4af59bb0aa5c'

  depends_on 'rlwrap'

  def install
    prefix.install "abcl.jar", "abcl-contrib.jar"
    (bin+"abcl").write <<-EOS.undent
      #!/bin/sh
      rlwrap java -jar "#{prefix}/abcl.jar" "$@"
    EOS
  end
end
