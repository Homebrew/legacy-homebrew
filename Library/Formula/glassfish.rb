class Glassfish < Formula
  desc "Java EE application server"
  homepage "https://glassfish.java.net"
  url "http://download.java.net/glassfish/4.1.1/release/glassfish-4.1.1.zip"
  sha256 "1b20d42b7d97d0282b90b3f6ec958138f1e81a500468f391ff5aa06afb599b9c"

  bottle :unneeded

  def install
    rm_rf Dir["bin/*.bat"]
    libexec.install Dir["*", ".org.opensolaris,pkg"]
  end

  def caveats; <<-EOS.undent
    The home of GlassFish Application Server 4 is:
      #{opt_libexec}

    You may want to add the following to your .bash_profile:
      export GLASSFISH_HOME=#{opt_libexec}
      export PATH=${PATH}:${GLASSFISH_HOME}/bin

    Note: The support scripts used by GlassFish Application Server 4
    are *NOT* linked to bin.
  EOS
  end
end
