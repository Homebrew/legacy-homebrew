require 'formula'

class Bazaar <Formula
  url 'http://launchpad.net/bzr/2.0/2.0.3/+download/bzr-2.0.3.tar.gz'
  md5 '60758e61b3fd3686966d7ab0ea17fa64'
  homepage 'http://bazaar-vcs.org/'
  
  def install
    ENV.minimal_optimization
    system "python", "setup.py", "build"
    system "python", "setup.py", "install", "--prefix=#{prefix}"
  end
end
