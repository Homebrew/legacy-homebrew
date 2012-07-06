require 'formula'

class Dc3dd < Formula
  homepage 'http://sourceforge.net/projects/dc3dd/'
  url 'http://downloads.sourceforge.net/project/dc3dd/dc3dd/7.1.0/dc3dd-7.1.614.tar.gz'
  md5 'b6c4ec16e7f539b17224d7f334f8396e'

  # Remove explicit dependency on automake 1.10.1
  def patches; DATA; end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}"
    system "make"
    system "make install"
    prefix.install %w[README Options_Reference.txt Sample_Commands.txt]
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index 5d1870a..b32639c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -32,7 +32,7 @@ AC_CONFIG_SRCDIR(src/dc3dd.c)
 AC_CONFIG_AUX_DIR(build-aux)
 AC_CONFIG_HEADERS([lib/config.h:lib/config.hin])
 
-AM_INIT_AUTOMAKE([1.10.1])
+AM_INIT_AUTOMAKE
 
 AC_PROG_CC_STDC
 AM_PROG_CC_C_O
