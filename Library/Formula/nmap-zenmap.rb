require 'formula'

def which_python
  "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
end

class NmapZenmap < Formula
  homepage 'http://nmap.org/6/'
  url 'http://nmap.org/dist/nmap-6.25.tar.bz2'
  sha1 '769943a1a5c10f67bf9738e26da42b3312db752f'

  head 'https://guest:@svn.nmap.org/nmap/', :using => :svn

  # Leopard's version of OpenSSL isn't new enough
  depends_on "openssl" if MacOS.version == :leopard
  # required for zenmap gui:
  depends_on :x11
  depends_on "pygtk"
  # echo export PYTHONPATH=\"$(brew --prefix)/lib/python2.7/site-packages:\$PYTHONPATH\" >> ~/.bash_profile

  fails_with :llvm do
    build 2334
  end

  def install
    ENV.deparallelize

    args = %W[--prefix=#{prefix}
              --with-libpcre=included
              --with-liblua=included
              --disable-universal]

    if MacOS.version == :leopard
      openssl = Formula.factory('openssl')
      args << "--with-openssl=#{openssl.prefix}"
    end

    system "./configure", *args
    system "make" # separate steps required otherwise the build fails
    system "make install"
  end

  def patches
    # Fixes Zenmap use of pygtk to work with non-brew python installation
    DATA
  end
end


__END__
diff --git a/zenmap/zenmapGUI/App.py b/zenmap/zenmapGUI/App.py
index 3c5f499..0e9c629 100644
--- a/zenmap/zenmapGUI/App.py
+++ b/zenmap/zenmapGUI/App.py
@@ -104,6 +104,11 @@ import ConfigParser
 import warnings
 warnings.filterwarnings("error", module = "gtk", append = "True")
 try:
+    # Executing zenmap via brew'ed install caused a 'No module named zenmapGUI.App'
+    # This appears to be linked to the local non-brew python not able to load
+    # gtk in a vanilla manner. The following worked from the pygtk Hello World:
+    import pygtk
+    pygtk.require('2.0')
     import gtk
 except Exception:
     # On Mac OS X 10.5, X11 is supposed to be automatically launched on demand.
