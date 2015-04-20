require 'formula'

class JbossAs < Formula
  homepage 'http://www.jboss.org/jbossas'
  url 'http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.tar.gz'
  version '7.1.1.Final'
  sha1 'fcec1002dce22d3281cc08d18d0ce72006868b6f'

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install Dir['*']
  end

  def caveats; <<-EOS.undent
    The home of JBoss Application Server 7 is:
      #{opt_libexec}

    You may want to add the following to your .bash_profile:
      export JBOSS_HOME=#{opt_libexec}
      export PATH=${PATH}:${JBOSS_HOME}/bin

    Note: The support scripts used by JBoss Application Server 7 have
    very generic names. These are likely to conflict with support scripts
    used by other Java-based server software. Hence they are *NOT* linked
    to bin.
  EOS
  end
end
