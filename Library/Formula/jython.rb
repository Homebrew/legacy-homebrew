require 'formula'

class Jython <Formula
  JAR = 'jython_installer-2.5.1.jar'
  url "http://downloads.sourceforge.net/project/jython/jython/2.5.1/#{JAR}"
  homepage 'http://www.jython.org'
  md5 '2ee978eff4306b23753b3fe9d7af5b37'

  def install
    system "java", "-jar", JAR, "-s", "-d", prefix
  end
end
