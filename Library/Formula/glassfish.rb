require 'formula'

class Glassfish < Formula
  homepage 'https://glassfish.java.net'
  url 'http://download.java.net/glassfish/4.0/release/glassfish-4.0.zip'
  sha1 'daca9808d80df35b26cd9545a84e8324ed34fe7e'

  # To keep empty folders around
  skip_clean 'libexec'

  def install
    rm_rf Dir['bin/*.bat']
    libexec.install Dir["*"]
    libexec.install Dir[".org.opensolaris,pkg"]
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
