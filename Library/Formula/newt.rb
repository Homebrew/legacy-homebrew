require 'formula'

class Newt < Formula
  homepage 'https://fedorahosted.org/newt/'
  url 'https://fedorahosted.org/releases/n/e/newt/newt-0.52.16.tar.gz'
  sha1 '678bf57e0a7e28db4da1a2951dbb65f9ce882f73'

  depends_on 'gettext'
  depends_on 'popt'
  depends_on 's-lang'
  depends_on :python => :optional

  def patches
    { :p0 => [ "https://trac.macports.org/export/111598/trunk/dports/devel/libnewt/files/patch-configure.ac.diff",
               "https://gist.github.com/co-me/6725961/raw/aa8bb06967ad5360eab89e22c1fe15b36bfa06e3/patch-Makefile.in.diff" ] }
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
