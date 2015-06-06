require 'formula'

class WildflyAs < Formula
  desc "Managed application runtime for building applications"
  homepage 'http://wildfly.org/'
  url 'http://download.jboss.org/wildfly/8.2.0.Final/wildfly-8.2.0.Final.tar.gz'
  sha1 'd78a864386a9bc08812eed9781722e45812a7826'

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
end
