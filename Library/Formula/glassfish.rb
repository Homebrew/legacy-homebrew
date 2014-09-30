require 'formula'

class Glassfish < Formula
  homepage 'https://glassfish.java.net'
  url 'http://dlc.sun.com.edgesuite.net/glassfish/4.1/release/glassfish-4.1.zip'
  sha1 '704a90899ec5e3b5007d310b13a6001575827293'

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
