require 'formula'

class Sip < Formula
  homepage 'http://www.riverbankcomputing.co.uk/software/sip'
  url 'http://download.sf.net/project/pyqt/sip/sip-4.14.7/sip-4.14.7.tar.gz'
  sha1 'ee048f6db7257d1eae2d9d2e407c1657c8888023'

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
      # To have sip (for 2.x) and sip3 for python3, we rename the sip binary:
      inreplace "configure.py", 'os.path.join(opts.sipbindir, "sip")', "os.path.join(opts.sipbindir, 'sip3')" if python3

      # Set --destdir such that the python modules will be in the HOMEBREWPREFIX/lib/pythonX.Y/site-packages
      system python, "configure.py",
                              "--destdir=#{lib}/#{python.xy}/site-packages",
                              "--bindir=#{bin}",
                              "--incdir=#{include}",
                              "--sipdir=#{HOMEBREW_PREFIX}/share/sip#{python.if3then3}"
      system "make"
      if python3
        bin.mkdir unless bin.exist?
        bin.install 'sipgen/sip' => 'sip3'
      end
      system "make install"
      system "make clean"
    end

  end

  def caveats
    s = ''
    s += python.standard_caveats if python
    s += "The sip-dir for Python #{python.version.major}.x is #{HOMEBREW_PREFIX}/share/sip#{python.if3then3}."
    s
  end

end
