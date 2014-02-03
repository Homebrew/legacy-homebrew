require 'formula'

class Sip < Formula
  homepage 'http://www.riverbankcomputing.co.uk/software/sip'
  url 'http://download.sf.net/project/pyqt/sip/sip-4.15.4/sip-4.15.4.tar.gz'
  sha1 'a5f6342dbb3cdc1fb61440ee8acb805f5fec3c41'

  head 'http://www.riverbankcomputing.co.uk/hg/sip', :using => :hg

  depends_on :python => :recommended
  depends_on :python3 => :optional


  odie 'sip: --with-python3 must be specified when using --without-python' if (!build.with? 'python3' and build.without? 'python')

  def install
    # default (python 2.x)
    unless build.without? 'python'
      ENV['PYTHONPATH'] = lib/'python2.7/site-packages'
      if build.head?
        # Link the Mercurial repository into the download directory so
        # buid.py can use it to figure out a version number.
        ln_s downloader.cached_location + '.hg', '.hg'
        system "python", "build.py", "prepare"
      end

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

    # optional (python 3.x)
    if build.with? 'python3'
      ENV['PYTHONPATH'] = lib/'python3.3/site-packages'
      if build.head?
        # Link the Mercurial repository into the download directory so
        # buid.py can use it to figure out a version number.
        ln_s downloader.cached_location + '.hg', '.hg'
        system "python3", "build.py", "prepare"
      end

      # Note the binary `sip` is the same for python 2.x and 3.x
      # Set --destdir such that the python modules will be in the HOMEBREWPREFIX/lib/pythonX.Y/site-packages
      system "python3", "configure.py",
                              "--deployment-target=#{MacOS.version}",
                              "--destdir=#{lib}/python3.3/site-packages",
                              "--bindir=#{bin}",
                              "--incdir=#{include}",
                              "--sipdir=#{HOMEBREW_PREFIX}/share/sip"
      system "make"
      system "make install"
      system "make clean"
    end
  end

  def caveats
    "The sip-dir for Python is #{HOMEBREW_PREFIX}/share/sip."
  end
end
