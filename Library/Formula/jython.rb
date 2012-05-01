require 'formula'

class Jython < Formula
  homepage 'http://www.jython.org'
  url "http://downloads.sourceforge.net/project/jython/jython/2.5.2/jython_installer-2.5.2.jar",
    :using => :nounzip
  sha1 'd4534a691edf40aa1d51723dfe3e22db1e39b432'

  devel do
    url "http://downloads.sourceforge.net/project/jython/jython-dev/2.5.3b1/jython_installer-2.5.3b1.jar",
      :using => :nounzip
    version '2.5.3b1'
    sha1 'bcfc024a93289b2f99bf000fb7666a48fe3d32da'
  end

  def install
    system "java", "-jar", "jython_installer-#{version}.jar", "-s", "-d", libexec
    bin.install_symlink libexec+'bin/jython'
  end
end
