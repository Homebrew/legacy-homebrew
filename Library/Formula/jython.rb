require 'formula'

class Jython <Formula
  url "http://downloads.sourceforge.net/project/jython/jython/2.5.2/jython_installer-2.5.2.jar",
    :using => :nounzip
  homepage 'http://www.jython.org'
  sha1 'd4534a691edf40aa1d51723dfe3e22db1e39b432'

  def install
    system "java", "-jar", Pathname.new(@url).basename, "-s", "-d", libexec
    bin.mkpath
    ln_s libexec+'bin/jython', bin
  end
end
