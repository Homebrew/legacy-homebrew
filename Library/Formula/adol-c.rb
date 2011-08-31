require 'formula'

class AdolC < Formula
  # install older version since 2.2.x doesn't work with PyADOLC
  url 'http://www.coin-or.org/download/source/ADOL-C/ADOL-C-2.1.12.tgz'
  homepage 'https://projects.coin-or.org/ADOL-C'
  md5 '9bb10fa14459790f711fff827becd682'

  depends_on 'aardvark_shell_utils' => :build  # for realpath
  depends_on 'colpack'

  def patches
      # fixes Makefile that doesn't propagate configure flags
      DATA
  end

  def install
    # readlink -f works on Linux but not OS X
    inreplace "configure" do |s|
        s.gsub! "readlink -f", "realpath"
    end
    # specifying "--disable-debug" causes configure to *enable* debug mode
    system "./configure", "--enable-sparse",
                          "--with-colpack="+`brew --prefix colpack`,
                          "--with-cxxflags=-O2 -D_ISOC99_SOURCE",
                          "--prefix=#{prefix}"
    system "make install"
    # use "brew -v install adol-c" to see the test results
    system "make test"
  end
end


__END__
diff --git a/ADOL-C/test/Makefile.in b/ADOL-C/test/Makefile.in
index b924017..038797c 100644
--- a/ADOL-C/test/Makefile.in
+++ b/ADOL-C/test/Makefile.in
@@ -231,6 +231,8 @@ AM_CPPFLAGS = -I$(srcdir)/../src/ \
 	-I$(srcdir)/../src/sparse \
 	-I$(srcdir)/../src/tapedoc 
 
+AM_CFLAGS = @ac_adolc_cflags@
+AM_CXXFLAGS = @ac_adolc_cxxflags@
 
 # This line is necessary to allow VPATH compilation with MS compilers
 # on Cygwin
