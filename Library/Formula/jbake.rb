require "formula"

class Jbake < Formula
  desc "Java based static site/blog generator"
  homepage "http://jbake.org"
  url "http://jbake.org/files/jbake-2.4.0-bin.zip"
  sha1 "e53633c6cd6ba714a8876cadc02fe41e7790c5db"

  def install
    rm_f Dir["bin/*.bat"]
    prefix.install_metafiles
    libexec.install Dir["*"]
    bin.write_jar_script "#{libexec}/jbake-core.jar", "jbake"
  end
end
