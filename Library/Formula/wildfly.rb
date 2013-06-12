require 'formula'

class Wildfly < Formula
  homepage 'http://www.wildfly.org'
  url 'http://download.jboss.org/wildfly/8.0.0.Alpha1/wildfly-8.0.0.Alpha1.zip'
  version '8.0.0.Alpha1'
  sha1 '5872b21521f63a2d817c3bedac1c8bcde13f00f6'

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install Dir['*']
  end

  def caveats; <<-EOS.undent
    WildFly is the new name for the community project, which
    was previously known as JBoss Application Server.

    The home of WildFly Application Server 8 is:
      #{opt_prefix}/libexec

    You may want to add the following to your .bash_profile:
      export JBOSS_HOME=#{opt_prefix}/libexec
      export PATH=${PATH}:${JBOSS_HOME}/bin

    Note: The support scripts used by WildFly Application Server 8 have
    very generic names. These are likely to conflict with support scripts
    used by other Java-based server software. Hence they are *NOT* linked
    to bin.
  EOS
  end
end
