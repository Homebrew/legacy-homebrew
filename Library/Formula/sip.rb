require 'formula'

class Sip < Formula
  homepage 'http://www.riverbankcomputing.co.uk/software/sip'
  url 'http://download.sf.net/project/pyqt/sip/sip-4.15.3/sip-4.15.3.tar.gz'
  sha1 'ef9916d36fedfd3cfa7161b5fd402f274ea0c99e'

  head 'http://www.riverbankcomputing.co.uk/hg/sip', :using => :hg

  depends_on :python => :recommended
  depends_on :python3 => :optional

  def install
    if build.head?
      # Link the Mercurial repository into the download directory so
      # buid.py can use it to figure out a version number.
      ln_s downloader.cached_location + '.hg', '.hg'
      system python, "build.py", "prepare"
    end

    # The python block is run once for each python (2.x and 3.x if requested)
    python do
      # Note the binary `sip` is the same for python 2.x and 3.x
      # Set --destdir such that the python modules will be in the HOMEBREWPREFIX/lib/pythonX.Y/site-packages
      system python, "configure.py",
                              "--destdir=#{lib}/#{python.xy}/site-packages",
                              "--bindir=#{bin}",
                              "--incdir=#{include}",
                              "--sipdir=#{HOMEBREW_PREFIX}/share/sip#{python.if3then3}"
      system "make"
      system "make install"
      system "make clean"
    end

  end

  def caveats
    s = ''
    s += python.standard_caveats if python
    s += "The sip-dir for Python 2.x is #{HOMEBREW_PREFIX}/share/sip.\n"
    s += "The sip-dir for Python 3.x is #{HOMEBREW_PREFIX}/share/sip3."
    s
  end
end
