require 'formula'

class Sip < Formula
  homepage 'http://www.riverbankcomputing.co.uk/software/sip'
  url 'http://download.sf.net/project/pyqt/sip/sip-4.15.4/sip-4.15.4.tar.gz'
  sha1 'a5f6342dbb3cdc1fb61440ee8acb805f5fec3c41'

  head 'http://www.riverbankcomputing.co.uk/hg/sip', :using => :hg

  depends_on :python => :recommended
  depends_on :python3 => :optional

  if build.without?("python3") && build.without?("python")
    odie 'sip: --with-python3 must be specified when using --without-python'
  end

  def pythons
    pythons_hash = {}
    # default (python 2.x)
    # regex to determine python version. e.g. 2.6 vs 2.7
    pythons_hash[:python] = /\d+(.)\d+/.match(`python --version 2>&1`) if build.with? "python"

    #optional (python 3.x)
    # regex to determine python version. e.g. 3.2 vs 3.3
    pythons_hash[:python3] = /\d+(.)\d+/.match(`python3 --version 2>&1`) if build.with? "python3"
    return pythons_hash
  end

  def install
    pythons.each do |python, version|
      ENV["PYTHONPATH"] = lib/"python#{version}/site-packages"

      if build.head?
        # Link the Mercurial repository into the download directory so
        # buid.py can use it to figure out a version number.
        ln_s downloader.cached_location + '.hg', '.hg'
        system python, 'build.py', 'prepare'
      end

      # Note the binary `sip` is the same for python 2.x and 3.x
      # Set --destdir such that the python modules will be in the HOMEBREWPREFIX/lib/pythonX.Y/site-packages
      system python, "configure.py",
                              "--deployment-target=#{MacOS.version}",
                              "--destdir=#{lib}/python#{version}/site-packages",
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
