require 'formula'

class JbossForge < Formula
  homepage 'http://jboss.org/forge'
  url 'https://repository.jboss.org/nexus/service/local/artifact/maven/redirect?r=releases&g=org.jboss.forge&a=forge-distribution&v=1.3.1.Final&e=zip'
  version '1.3.1.Final'
  sha1 'e693734821045e4c5dd9872bf8e36bfbd2891130'

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w{ bin modules jboss-modules.jar }
    bin.install_symlink libexec/'bin/forge'
  end
end
