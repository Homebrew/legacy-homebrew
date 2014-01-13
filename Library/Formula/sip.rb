require 'formula'

class Sip < Formula
  homepage 'http://www.riverbankcomputing.co.uk/software/sip'
  url 'http://download.sf.net/project/pyqt/sip/sip-4.15.4/sip-4.15.4.tar.gz'
  sha1 'a5f6342dbb3cdc1fb61440ee8acb805f5fec3c41'

  head 'http://www.riverbankcomputing.co.uk/hg/sip', :using => :hg

  def install
    if build.head?
      # Link the Mercurial repository into the download directory so
      # buid.py can use it to figure out a version number.
      ln_s downloader.cached_location + '.hg', '.hg'
      system "python", "build.py", "prepare"
    end

    # The python block is run once for each python (2.x and 3.x if requested)
    # Note the binary `sip` is the same for python 2.x and 3.x
    # Set --destdir such that the python modules will be in the HOMEBREWPREFIX/lib/pythonX.Y/site-packages
    system "python", "configure.py",
                            "--deployment-target=#{MacOS.version}",
                            "--destdir=#{lib}/python2.7/site-packages",
                            "--bindir=#{bin}",
                            "--incdir=#{include}",
                            "--sipdir=#{HOMEBREW_PREFIX}/share/sip"
    system "make"
    system "make install"
    system "make clean"
  end

  def caveats
    "The sip-dir for Python 2.x is #{HOMEBREW_PREFIX}/share/sip."
  end
end
