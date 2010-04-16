require 'formula'

class Bazaar <Formula
  url 'http://launchpadlibrarian.net/41811693/bzr-2.1.1.tar.gz'
  md5 'ab6b5e0cc449b27abac2b4d717afe09d'
  homepage 'http://bazaar-vcs.org/'
  
  aka :bzr

  def install
    # Find the archs of the Python we are building against.
    # If the python includes PPC support, then don't use Intel-
    # specific compiler flags
    archs = archs_for_command("python")
    ENV.minimal_optimization if archs.include? :ppc64 or archs.include? :ppc7400

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
