require 'formula'

class Scons <Formula
  url 'http://prdownloads.sourceforge.net/scons/scons-1.2.0.d20090919.tar.gz'
  homepage 'http://www.scons.org'
  md5 'd95c3749438e51db592b854683083965'

  def install
    system "python", "setup.py", "install", "--prefix=#{prefix}"
  end
end
