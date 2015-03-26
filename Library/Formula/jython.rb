require 'formula'

class Jython < Formula
  homepage 'http://www.jython.org'
  url 'http://search.maven.org/remotecontent?filepath=org/python/jython-installer/2.5.3/jython-installer-2.5.3.jar'
  sha1 '6b6ac4354733b6d68d51acf2f3d5c823a10a4ce4'

  devel do
    url 'http://search.maven.org/remotecontent?filepath=org/python/jython-installer/2.7-rc1/jython-installer-2.7-rc1.jar'
    sha1 '772b88e129612cc30636b36d3d9ea47bd18666ec'
  end

  def install
    system "java", "-jar", cached_download, "-s", "-d", libexec
    inreplace libexec/'bin/jython', 'PRG=$0', "PRG=#{libexec}/bin/jython"
    bin.install_symlink libexec/'bin/jython'
  end
end
