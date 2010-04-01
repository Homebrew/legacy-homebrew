require 'formula'

class Scons <Formula
  url 'http://downloads.sourceforge.net/project/scons/scons/1.3.0/scons-1.3.0.tar.gz'
  homepage 'http://www.scons.org'
  md5 'ad6838c867abd2ad5bf371b353d594f7'

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
