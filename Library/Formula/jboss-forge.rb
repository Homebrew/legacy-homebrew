require 'formula'

class JbossForge < Formula
  homepage 'http://forge.jboss.org/'
  url 'https://repository.jboss.org/nexus/service/local/artifact/maven/redirect?r=releases&g=org.jboss.forge&a=forge-distribution&v=2.12.3.Final&e=zip&c=offline'
  version '2.12.3.Final'
  sha1 '86cb164f7553f227ca9689b48c518e1963df3a79'

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w{ addons bin img lib logging.properties }
    bin.install_symlink libexec/'bin/forge'
  end
end
