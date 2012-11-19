require 'formula'

class JbossForge < Formula
  homepage 'http://jboss.org/forge'
  url 'https://repository.jboss.org/nexus/service/local/artifact/maven/redirect?r=releases&g=org.jboss.forge&a=forge-distribution&v=1.1.1.Final&e=zip'
  version '1.1.1.Final'
  sha1 '8e197cb19103402a101acbe779d4e07a9ac125b3'

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w{ bin modules jboss-modules.jar }
    bin.install_symlink libexec/'bin/forge'
  end
end
