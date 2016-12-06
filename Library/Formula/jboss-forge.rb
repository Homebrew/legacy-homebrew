require 'formula'

class JbossForge < Formula
  homepage 'http://jboss.org/forge'
  version '1.0.0.CR2'
  url 'https://repository.jboss.org/nexus/service/local/artifact/maven/redirect?r=releases&g=org.jboss.forge&a=forge-distribution&v=1.0.0.CR2&e=zip'
  md5 'b667e58d5c9f6e514403ca3efafbd8a5'


  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin modules jboss-modules.jar]
    prefix.install %w{ LICENSE.txt README.txt }
    bin.mkpath
    ln_s libexec+('bin/forge'), bin
  end
end
