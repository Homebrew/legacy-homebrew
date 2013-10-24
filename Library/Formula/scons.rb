require 'formula'

class Scons < Formula
  homepage 'http://www.scons.org'
  url 'http://downloads.sourceforge.net/scons/scons-2.3.0.tar.gz'
  sha1 '728edf20047a9f8a537107dbff8d8f803fd2d5e3'

  depends_on :python

  def install
    man1.install gzip('scons-time.1', 'scons.1', 'sconsign.1')
    python do
      system python, "setup.py", "install",
             "--prefix=#{prefix}",
             "--standalone-lib",
             # SCons gets handsy with sys.path---`scons-local` is one place it
             # will look when all is said and done.
             "--install-data=#{libexec}",
             "--no-version-script", "--no-install-man"
    end
  end
end
