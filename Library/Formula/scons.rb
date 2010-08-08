require 'formula'

class Scons <Formula
  url 'http://prdownloads.sourceforge.net/scons/scons-2.0.0.final.0.tar.gz'
  homepage 'http://www.scons.org'
  md5 'c2e4c2700cac507caa93d4a3adbbf56f'
  version '2.0.0'

  def install
    man1.install [gzip('scons-time.1'), gzip('scons.1'), gzip('sconsign.1')]
    system "python", "setup.py", "install",
                     "--prefix=#{prefix}",
                     "--standalone-lib",
                     "--no-version-script", "--no-install-man"
  end
end
