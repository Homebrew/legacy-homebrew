require "formula"

class Jbake < Formula
  homepage "http://jbake.org"
  url "http://jbake.org/files/jbake-2.3.1-bin.zip"
  sha1 "b429a89a66c021a70394e0207d71a703de58d85b"

  def install
    rm_f Dir["bin/*.bat"]
    prefix.install_metafiles
    libexec.install Dir["*"]
    bin.write_jar_script "#{libexec}/jbake-core.jar", "jbake"
  end
end
