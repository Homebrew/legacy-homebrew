require 'formula'

class Bazaar <Formula
  url 'http://launchpadlibrarian.net/41811693/bzr-2.1.1.tar.gz'
  md5 'ab6b5e0cc449b27abac2b4d717afe09d'
  homepage 'http://bazaar-vcs.org/'
  
  aka :bzr

  def install
    # Make the manual before we install (mv) bzrlib
    system "make man1/bzr.1"
    man1.install gzip('man1/bzr.1')

    system "make"
    libexec.install ['bzr', 'bzrlib']

    bin.mkpath
    ln_s libexec+'bzr', bin+'bzr'
  end

  def caveats
    <<-EOS.undent
    We've built a "standalone" version of bazaar and installed its libraries to:
      #{libexec}

    We've specifically kept it out of your Python's "site-packages" folder.
    EOS
  end
end
