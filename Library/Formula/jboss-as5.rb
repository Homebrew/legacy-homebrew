require "formula"

class JbossAs5 < Formula
  homepage "http://www.jboss.org/jbossas"
  url "http://sourceforge.net/projects/jboss/files/JBoss/JBoss-5.1.0.GA/jboss-5.1.0.GA.zip/download"
  sha1 "be05d9e4774c60cc7473e2fdd0b1fff228ef7b38"
  version "5.1.0GA"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install Dir['*']
  end

  def caveats; <<-EOS.undent
      The home of JBoss Application Server 5 is:
      #{libexec}

      You may want to add the following to your .bash_profile:
        export JBOSS_HOME=#{libexec}
        export PATH=${PATH}:${JBOSS_HOME}/bin

      Note: The support scripts used by JBoss Application Server 5 have
      very generic names. These are likely to conflict with support scripts
      used by other Java-based server software. Hence they are *NOT* linked
      to bin.
    EOS
  end
end
