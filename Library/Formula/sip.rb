require 'formula'

class Sip < Formula
  homepage 'http://www.riverbankcomputing.co.uk/software/sip'
  url 'http://download.sf.net/project/pyqt/sip/sip-4.15.4/sip-4.15.4.tar.gz'
  sha1 'a5f6342dbb3cdc1fb61440ee8acb805f5fec3c41'

  bottle do
    sha1 "0d3972d76485971c2c8088c8f6329814eb452687" => :mavericks
    sha1 "ed7500d9d8f0d41cc2ab0dfa76998b52b1f26bfb" => :mountain_lion
    sha1 "f5322f040c742656407e16a141adde0d2324d532" => :lion
  end

  head 'http://www.riverbankcomputing.co.uk/hg/sip', :using => :hg

  depends_on :python => :recommended
  depends_on :python3 => :optional

  if build.without?("python3") && build.without?("python")
    odie "sip: --with-python3 must be specified when using --without-python"
  end

  def install
    if build.head?
      # Link the Mercurial repository into the download directory so
      # build.py can use it to figure out a version number.
      ln_s cached_download + ".hg", ".hg"
      # build.py doesn't run with python3
      system "python", "build.py", "prepare"
    end

    Language::Python.each_python(build) do |python, version|
      # Note the binary `sip` is the same for python 2.x and 3.x
      system python, "configure.py",
                     "--deployment-target=#{MacOS.version}",
                     "--destdir=#{lib}/python#{version}/site-packages",
                     "--bindir=#{bin}",
                     "--incdir=#{include}",
                     "--sipdir=#{HOMEBREW_PREFIX}/share/sip"
      system "make"
      system "make", "install"
      system "make", "clean"
    end
  end

  def caveats
    "The sip-dir for Python is #{HOMEBREW_PREFIX}/share/sip."
  end
end
