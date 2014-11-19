require 'formula'

class JbossForge < Formula
  homepage 'http://forge.jboss.org/'
  url 'https://repository.jboss.org/nexus/service/local/artifact/maven/redirect?r=releases&g=org.jboss.forge&a=forge-distribution&v=2.12.2.Final&e=zip&c=offline'
  version '2.12.2.Final'
  sha1 'ec682cbda6fbdea7155dc00d6af9338a38b12cc6'

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w{ addons bin img lib logging.properties }
    bin.install_symlink libexec/'bin/forge'
  end
end
