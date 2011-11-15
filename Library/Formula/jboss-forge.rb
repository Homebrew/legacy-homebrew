require 'formula'

class JbossForge < Formula
  homepage 'http://jboss.org/forge'
  version '1.0.0.Beta3'
  url 'https://repository.jboss.org/nexus/service/local/artifact/maven/redirect?r=releases&g=org.jboss.forge&a=forge-distribution&v=1.0.0.Beta3&e=zip'
  md5 '870855a1ff9417c5cfcdad9c3c683ccb'


  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin modules jboss-modules.jar]
    prefix.install %w{ licence.txt readme.txt }
    bin.mkpath
    ln_s libexec+('bin/forge'), bin
  end
end
