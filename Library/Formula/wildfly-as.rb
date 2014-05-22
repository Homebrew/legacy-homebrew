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
      #{opt_libexec}
    You may want to add the following to your .bash_profile:
      export JBOSS_HOME=#{opt_libexec}
      export PATH=${PATH}:${JBOSS_HOME}/bin
    EOS
  end

  test do
    system "#{opt_libexec}/bin/standalone.sh --version | grep #{version}"
  end

  devel do
    url 'http://download.jboss.org/wildfly/8.1.0.CR1/wildfly-8.1.0.CR1.tar.gz'
    sha1 '66cc7a470382e12ae6baee1c7011c44253bf84fe'
  end

end
