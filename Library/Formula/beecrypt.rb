require 'formula'

class Beecrypt < Formula
  homepage 'http://beecrypt.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/beecrypt/beecrypt/4.2.1/beecrypt-4.2.1.tar.gz'
  sha256 '286f1f56080d1a6b1d024003a5fa2158f4ff82cae0c6829d3c476a4b5898c55d'

  depends_on "icu4c"
  depends_on :python => :optional

  def patches
    # fix build with newer clang, gcc 4.7 (https://bugs.gentoo.org/show_bug.cgi?id=413951)
    { :p0 => DATA }
  end

  def darwin_major_version
    # kern.osrelease: 11.4.2
    full_version = `/usr/sbin/sysctl -n kern.osrelease`
    full_version.split("\.")[0]
  end

  def install
    ENV.remove_from_cflags(/-march=\S*/)
    args = ["--prefix=#{prefix}", "--disable-openmp", "--without-java"]
    if MacOS.prefer_64_bit?
      args << "--build=x86_64-apple-darwin#{darwin_major_version}"
    end

    args << "--without-python" if build.without? 'python'

    if python
      # We don't want beecrypt to use get_python_lib() to install into
      # the global site-packages. There is no option to set it.
      # Fixing this in configure make the configure output printout correct.
      inreplace "configure", "ac_cv_python_libdir=`$PYTHON -c 'import distutils.sysconfig; print distutils.sysconfig.get_python_lib()'`",
                             "ac_cv_python_libdir='#{python.site_packages}'"
    end
    system "./configure", *args
    system "make"
    system "make install"
    # We have to move the check after install (which is stupid, I know) but
    # otherwise they fail because python bindings don't yet find the libbeecrypt
    system "make check"
  end
end

__END__
--- include/beecrypt/c++/util/AbstractSet.h~	2009-06-17 13:05:55.000000000 +0200
+++ include/beecrypt/c++/util/AbstractSet.h	2012-06-03 17:45:55.229399461 +0200
@@ -56,7 +56,7 @@
 					if (c->size() != size())
 						return false;
 
-					return containsAll(*c);
+					return this->containsAll(*c);
 				}
 				return false;
 			}
