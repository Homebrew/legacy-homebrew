class Jbake < Formula
  desc "Java based static site/blog generator"
  homepage "http://jbake.org"
  url "http://jbake.org/files/jbake-2.4.0-bin.zip"
  sha256 "c255b34ac0a87b5fe8f679e59375651f6bcc0e575da6209841c80a2e07d16cc4"

  def install
    rm_f Dir["bin/*.bat"]
    prefix.install_metafiles
    libexec.install Dir["*"]
    bin.write_jar_script "#{libexec}/jbake-core.jar", "jbake"
  end
end
