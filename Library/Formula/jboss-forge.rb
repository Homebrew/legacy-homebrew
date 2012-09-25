require 'formula'

class JbossForge < Formula
  homepage 'http://jboss.org/forge'
  url 'https://repository.jboss.org/nexus/service/local/artifact/maven/redirect?r=releases&g=org.jboss.forge&a=forge-distribution&v=1.0.5.Final&e=zip'
  version '1.0.5.Final'
  sha1 '496c04e21cb036561669e6939b69805d571737d3'

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w{ bin modules jboss-modules.jar }
    bin.install_symlink libexec/'bin/forge'
  end
end
