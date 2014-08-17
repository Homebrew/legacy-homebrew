require 'formula'

class Newt < Formula
  homepage 'https://fedorahosted.org/newt/'
  url 'https://fedorahosted.org/releases/n/e/newt/newt-0.52.16.tar.gz'
  sha1 '678bf57e0a7e28db4da1a2951dbb65f9ce882f73'

  depends_on 'gettext'
  depends_on 'popt'
  depends_on 's-lang'
  depends_on :python => :optional

  patch :p0 do
    url "https://trac.macports.org/export/111598/trunk/dports/devel/libnewt/files/patch-configure.ac.diff"
    sha1 "d01bd0d8cd2b679c26f0f443bde495a52abe5a4f"
  end

  patch :p0 do
    url "https://gist.githubusercontent.com/co-me/6725961/raw/aa8bb06967ad5360eab89e22c1fe15b36bfa06e3/patch-Makefile.in.diff"
    sha1 "8cd3b609cd7dffbc2abf00454dcba0a78967bce7"
  end

  def install
    args = ["--prefix=#{prefix}", "--without-tcl"]
    args << "--without-python" if build.without? 'python'
    system "./configure", *args
    system "make install"
  end
end
