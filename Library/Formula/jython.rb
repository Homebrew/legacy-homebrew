require 'formula'

class Jython < Formula
  homepage 'http://www.jython.org'
  url 'http://search.maven.org/remotecontent?filepath=org/python/jython-installer/2.5.3/jython-installer-2.5.3.jar'
  sha1 '6b6ac4354733b6d68d51acf2f3d5c823a10a4ce4'

  devel do
    url 'http://search.maven.org/remotecontent?filepath=org/python/jython-installer/2.7-rc2/jython-installer-2.7-rc2.jar'
    sha1 'd9e1f57d387b0e9d19d29eeb3c860175456e6077'
  end

  def install
    system "java", "-jar", cached_download, "-s", "-d", libexec
    inreplace libexec/'bin/jython', 'PRG=$0', "PRG=#{libexec}/bin/jython"
    bin.install_symlink libexec/'bin/jython'
  end
end
