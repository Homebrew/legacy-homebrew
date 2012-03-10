require 'formula'

class Scons < Formula
  url 'http://downloads.sourceforge.net/project/scons/scons/2.1.0/scons-2.1.0.tar.gz'
  homepage 'http://www.scons.org'
  md5 '47daf989e303a045b76c11236df719df'

  def install
    man1.install gzip('scons-time.1', 'scons.1', 'sconsign.1')
    system "/usr/bin/python", "setup.py", "install",
             "--prefix=#{prefix}",
             "--standalone-lib",
             "--no-version-script", "--no-install-man"
  end
end
