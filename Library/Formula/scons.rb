require 'formula'

class Scons <Formula
  url 'http://prdownloads.sourceforge.net/scons/scons-1.2.0.d20090919.tar.gz'
  homepage 'http://www.scons.org'
  md5 'd95c3749438e51db592b854683083965'

  def install
    man1.install gzip('scons-time.1')
    man1.install gzip('scons.1')
    man1.install gzip('sconsign.1')

    system "python", "setup.py", "install",
                    "--prefix=#{prefix}",
                    "--standalone-lib",
                    "--no-version-script", "--no-install-man"
  end
end
