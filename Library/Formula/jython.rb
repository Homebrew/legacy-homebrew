require 'formula'

class Jython <Formula
  url "http://downloads.sourceforge.net/project/jython/jython/2.5.1/jython_installer-2.5.1.jar",
    :using => :nounzip
  homepage 'http://www.jython.org'

  head "http://downloads.sourceforge.net/project/jython/jython-dev/2.5.2rc3/jython_installer-2.5.2rc3.jar",
    :using => :nounzip

  if ARGV.build_head?
    sha1 '547c424a119661ed1901079ff8f4e45af7d57b56'
  else
    md5 '2ee978eff4306b23753b3fe9d7af5b37'
  end

  def install
    system "java", "-jar", Pathname.new(@url).basename, "-s", "-d", libexec
    bin.mkpath
    ln_s libexec+'bin/jython', bin
  end
end
