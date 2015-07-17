require 'formula'

class JbossForge < Formula
  desc "Tools to help set up and configure a project"
  homepage 'http://forge.jboss.org/'
  url 'https://repository.jboss.org/nexus/service/local/artifact/maven/redirect?r=releases&g=org.jboss.forge&a=forge-distribution&v=2.17.0.Final&e=zip&c=offline'
  version '2.17.0.Final'
  sha256 'c0d8cadb315b23d99fb582db670ef32beea51b9b06ea9313ec81daa3998bedd8'

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w{ addons bin img lib logging.properties }
    bin.install_symlink libexec/'bin/forge'
  end
end
