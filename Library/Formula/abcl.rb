require 'formula'

class Abcl < Formula
  homepage 'http://abcl.org'
  url 'http://abcl.org/releases/1.2.1/abcl-bin-1.2.1.tar.gz'
  sha1 '7936d9f8deb3eb064a265b0b620f033ee4db6ed8'

  depends_on 'rlwrap'

  def install
    prefix.install "abcl.jar", "abcl-contrib.jar"
    (bin+"abcl").write <<-EOS.undent
      #!/bin/sh
      rlwrap java -jar "#{prefix}/abcl.jar" "$@"
    EOS
  end
end
