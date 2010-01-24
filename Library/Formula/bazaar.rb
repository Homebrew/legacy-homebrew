require 'formula'

class Bazaar <Formula
  url 'http://launchpad.net/bzr/2.0/2.0.3/+download/bzr-2.0.3.tar.gz'
  md5 '60758e61b3fd3686966d7ab0ea17fa64'
  homepage 'http://bazaar-vcs.org/'
  
  aka :bzr

  def install
    ENV.minimal_optimization
    inreplace 'setup.py', 'man/man1', 'share/man/man1'
    system "python", "setup.py", "build"
    system "python", "setup.py", "install", "--prefix=#{prefix}"
  end

  def caveats; <<-EOS
Really Bazaar should be installed by easy_install or pip, but currently this
doesn't work properly. As a result you need to set PYTHONPATH:

    export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/python2.6/site-packages

    EOS
  end
end
