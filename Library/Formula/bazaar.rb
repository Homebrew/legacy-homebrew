require 'formula'

class Bazaar <Formula
  url 'http://launchpad.net/bzr/2.0/2.0.2/+download/bzr-2.0.2.tar.gz'
  homepage 'http://bazaar-vcs.org/'
  md5 '845743611ef6f1ece8e7bf9824c0bb95'
  
  def install
    ENV.minimal_optimization
    system "python setup.py build"
    system "python", "setup.py", "install", "--prefix=#{prefix}"
  end
end
