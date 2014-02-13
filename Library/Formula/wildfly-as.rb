require 'formula'

class WildflyAs < Formula
  homepage 'http://wildfly.org/'
  url 'http://download.jboss.org/wildfly/8.0.0.Final/wildfly-8.0.0.Final.tar.gz'
  sha1 '594f78aa04dd35c936615563ff3777a67228ba9d'

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install Dir['*']
  end

  def caveats; <<-EOS.undent
    The home of WildFly Application Server 8 is:
      #{opt_prefix}/libexec

    You may want to add the following to your .bash_profile:
      export JBOSS_HOME=#{opt_prefix}/libexec
      export PATH=${PATH}:${JBOSS_HOME}/bin

    Note: WildFly 8 still uses JBOSS_HOME, do not use WILDFLY_HOME or something like that.

    Note: The support scripts used by WildFly Application Server 7 have
    very generic names. These are likely to conflict with support scripts
    used by other Java-based server software. Hence they are *NOT* linked
    to bin.
  EOS
  end
end
