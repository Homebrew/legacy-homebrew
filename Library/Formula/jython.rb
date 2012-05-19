require 'formula'

class Jython < Formula
  homepage 'http://www.jython.org'
  url "http://downloads.sourceforge.net/project/jython/jython/2.5.2/jython_installer-2.5.2.jar"
  sha1 'd4534a691edf40aa1d51723dfe3e22db1e39b432'

  devel do
    url "http://downloads.sourceforge.net/project/jython/jython-dev/2.7.0a1/jython_installer-2.7a1.jar"
    sha1 'c2fc5232da2c9de0cca357bf4fa5dc312bbf1294'
  end

  def install
    system "java", "-jar", "jython_installer-#{version}.jar", "-s", "-d", libexec
    bin.install_symlink libexec/'bin/jython'
  end
end
