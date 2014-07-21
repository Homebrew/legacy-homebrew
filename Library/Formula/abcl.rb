require "formula"

class Abcl < Formula
  homepage "http://abcl.org"
  url "http://abcl.org/releases/1.3.1/abcl-bin-1.3.1.tar.gz"
  sha1 "7abb22130acfbca9d01c413da9c98a6aa078c78b"

  depends_on "rlwrap"

  def install
    libexec.install "abcl.jar", "abcl-contrib.jar"
    (bin+"abcl").write <<-EOS.undent
      #!/bin/sh
      rlwrap java -jar "#{libexec}/abcl.jar" "$@"
    EOS
  end
end
