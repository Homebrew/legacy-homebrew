class WildflyAs < Formula
  desc "Managed application runtime for building applications"
  homepage "http://wildfly.org/"
  url "https://download.jboss.org/wildfly/9.0.2.Final/wildfly-9.0.2.Final.tar.gz"
  sha256 "74689569d6e04402abb7d94921c558940725d8065dce21a2d7194fa354249bb6"

  bottle :unneeded

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
