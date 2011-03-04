require 'formula'

class Jython <Formula
  url "http://downloads.sourceforge.net/project/jython/jython/2.5.1/jython_installer-2.5.1.jar",
    :using => :nounzip
  md5 '2ee978eff4306b23753b3fe9d7af5b37'
  homepage 'http://www.jython.org'
  head "http://downloads.sourceforge.net/project/jython/jython-dev/2.5.2b2/jython_installer-2.5.2b2.jar",
    :using => :nounzip

  def install
    system "java", "-jar", Pathname.new(@url).basename, "-s", "-d", libexec
    bin.mkpath
    ln_s libexec+'bin/jython', bin
  end
end
