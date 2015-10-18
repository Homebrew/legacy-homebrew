class WildflyAs < Formula
  desc "Managed application runtime for building applications"
  homepage "http://wildfly.org/"
  url "https://download.jboss.org/wildfly/9.0.1.Final/wildfly-9.0.1.Final.tar.gz"
  sha256 "8f570f978dff65a006c1c6cb58c26a3856b19f01dad5b2a3ef9e463c8dee2a54"

  def install
    rm_f Dir["bin/*.bat"]
    rm_f Dir["bin/*.ps1"]
    libexec.install Dir["*"]
  end

  def caveats; <<-EOS.undent
    The home of WildFly Application Server 9 is:
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
