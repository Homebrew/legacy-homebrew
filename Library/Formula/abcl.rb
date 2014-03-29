require 'formula'

class Abcl < Formula
  homepage 'http://abcl.org'
  url 'http://abcl.org/releases/1.3.0/abcl-bin-1.3.0.tar.gz'
  sha1 '06704f96418b1a39ed0d774569c102af4c1606d8'

  depends_on 'rlwrap'

  def install
    prefix.install "abcl.jar", "abcl-contrib.jar"
    (bin+"abcl").write <<-EOS.undent
      #!/bin/sh
      rlwrap java -jar "#{prefix}/abcl.jar" "$@"
    EOS
  end
end
