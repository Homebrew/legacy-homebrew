require 'formula'

class Newt < Formula
  homepage 'https://fedorahosted.org/newt/'
  url 'https://fedorahosted.org/releases/n/e/newt/newt-0.52.15.tar.gz'
  sha1 'e067280e474eb327c62eaa306e2242adcf540ab2'

  depends_on 'gettext'
  depends_on 'popt'
  depends_on 's-lang'
  depends_on :python => :optional

  def patches
    { :p0 => [ "https://trac.macports.org/export/106061/trunk/dports/devel/libnewt/files/patch-configure.ac.diff",
               "https://trac.macports.org/export/106061/trunk/dports/devel/libnewt/files/patch-Makefile.in.diff" ] }
  end

  def install
    args = ["--prefix=#{prefix}", "--without-tcl"]
    args << "--without-python" if build.without? 'python'
    system "./configure", *args
    system "make install"
  end

  def caveats
    python.standard_caveats if python
  end
end
