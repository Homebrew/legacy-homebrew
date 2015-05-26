require "formula"

class Jbake < Formula
  homepage "http://jbake.org"
  url "http://jbake.org/files/jbake-2.3.2-bin.zip"
  sha1 "8daa2603b0277ee92ba216cf1d7e2d706f489382"

  def install
    rm_f Dir["bin/*.bat"]
    prefix.install_metafiles
    libexec.install Dir["*"]
    bin.write_jar_script "#{libexec}/jbake-core.jar", "jbake"
  end
end
