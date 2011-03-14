require 'formula'

class Scons < Formula
  url 'http://downloads.sourceforge.net/project/scons/scons/2.0.1/scons-2.0.1.tar.gz'
  homepage 'http://www.scons.org'
  md5 'beca648b894cdbf85383fffc79516d18'
  version '2.0.1'

  def install
    man1.install gzip('scons-time.1', 'scons.1', 'sconsign.1')
    system "python", "setup.py", "install",
                     "--prefix=#{prefix}",
                     "--standalone-lib",
                     "--no-version-script", "--no-install-man"
  end
end
