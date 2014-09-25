require 'formula'

class JbossForge < Formula
  homepage 'http://forge.jboss.org/'
  url 'https://repository.jboss.org/nexus/service/local/artifact/maven/redirect?r=releases&g=org.jboss.forge&a=forge-distribution&v=2.10.1.Final&e=zip&c=offline'
  version '2.10.1.Final'
  sha1 'c68559486092868093162d3ab6daa3729ae539a9'

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w{ addons bin img lib logging.properties }
    bin.install_symlink libexec/'bin/forge'
  end
end
