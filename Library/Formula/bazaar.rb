require 'formula'

class Bazaar <Formula
  url 'http://launchpadlibrarian.net/41811693/bzr-2.1.1.tar.gz'
  md5 'ab6b5e0cc449b27abac2b4d717afe09d'
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
