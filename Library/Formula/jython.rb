require 'formula'

class Jython < Formula
  homepage 'http://www.jython.org'
  url "http://search.maven.org/remotecontent?filepath=org/python/jython-installer/2.5.3/jython-installer-2.5.3.jar"
  sha1 '6b6ac4354733b6d68d51acf2f3d5c823a10a4ce4'

  devel do
    url "http://downloads.sourceforge.net/project/jython/jython-dev/2.7.0a2/jython_installer-2.7a2.jar"
    sha1 'b4a0bd80800221d9a6b5462120c327e27b307544'
  end

  def install
    system "java", "-jar", cached_download, "-s", "-d", libexec
    bin.install_symlink libexec/'bin/jython'
  end
end
