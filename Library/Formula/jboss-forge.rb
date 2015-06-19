require 'formula'

class JbossForge < Formula
  desc "Tools to help set up and configure a project"
  homepage 'http://forge.jboss.org/'
  url 'https://repository.jboss.org/nexus/service/local/artifact/maven/redirect?r=releases&g=org.jboss.forge&a=forge-distribution&v=2.16.2.Final&e=zip&c=offline'
  version '2.16.2.Final'
  sha1 'b8588f7b7bb26a0349e33c61cbb1663b6b96040c'

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w{ addons bin img lib logging.properties }
    bin.install_symlink libexec/'bin/forge'
  end
end
