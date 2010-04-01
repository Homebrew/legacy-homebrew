require 'formula'

class Bazaar <Formula
  url 'http://launchpad.net/bzr/2.1/2.1.0/+download/bzr-2.1.0.tar.gz'
  md5 'ea184d6cfb22cf4e92ee275f593ca88d'
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
