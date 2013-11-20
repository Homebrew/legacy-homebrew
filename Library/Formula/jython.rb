require 'formula'

class Jython < Formula
  homepage 'http://www.jython.org'
  url 'http://search.maven.org/remotecontent?filepath=org/python/jython-installer/2.5.3/jython-installer-2.5.3.jar'
  sha1 '6b6ac4354733b6d68d51acf2f3d5c823a10a4ce4'

  devel do
    url 'http://search.maven.org/remotecontent?filepath=org/python/jython-installer/2.7-b1/jython-installer-2.7-b1.jar'
    version '2.7-b1'
    sha1 '385a52a8a3c5d941d61a7b2ed76e8a351b3658f2'
  end

  def install
    system "java", "-jar", cached_download, "-s", "-d", libexec
    inreplace libexec/'bin/jython', 'PRG=$0', "PRG=#{libexec}/bin/jython"
    bin.install_symlink libexec/'bin/jython'
  end

  def caveats; <<-EOS.undent
    To be able to use the Jython Launcher you will have to set
    the JYTHON_HOME environment variable.

    For bash, zsh & co:
      export JYTHON_HOME=#{opt_prefix}/libexec

    For fish:
      set -x JYTHON_HOME #{opt_prefix}/libexec

    Now you can simply run `jython` on the command line to start
    Jython.
    EOS
  end
end
