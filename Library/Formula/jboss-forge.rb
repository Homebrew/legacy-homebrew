require 'formula'

class JbossForge < Formula
  homepage 'http://forge.jboss.org/'
  url 'https://repository.jboss.org/nexus/service/local/artifact/maven/redirect?r=releases&g=org.jboss.forge&a=forge-distribution&v=2.13.0.Final&e=zip&c=offline'
  version '2.13.0.Final'
  sha1 '02498befaae7ca3cd8dc22370c02bad07d951811'

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w{ addons bin img lib logging.properties }
    bin.install_symlink libexec/'bin/forge'
  end
end
