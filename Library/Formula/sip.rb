require 'formula'

class Sip < Formula
  homepage 'http://www.riverbankcomputing.co.uk/software/sip'
  url "https://downloads.sf.net/project/pyqt/sip/sip-4.16.3/sip-4.16.3.tar.gz"
  sha1 "7c4079d164ccbfe4a5274eaeebe8e3cc86e3a75a"

  bottle do
    revision 1
    sha1 "724af0277f4ec4635f86a011432a01206a81ea1e" => :yosemite
    sha1 "4410671269f1f46de216cb189debe973333b9965" => :mavericks
    sha1 "5aac602b4d22d471a59c517809dc1159545cba9f" => :mountain_lion
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

  def post_install
    mkdir_p "#{HOMEBREW_PREFIX}/share/sip"
  end

  def caveats
    "The sip-dir for Python is #{HOMEBREW_PREFIX}/share/sip."
  end
end
