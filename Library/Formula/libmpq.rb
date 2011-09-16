require 'formula'

class Libmpq < Formula
  # libmpq.org has seen prolonged downtime
  head 'https://github.com/ge0rg/libmpq.git'
  homepage 'https://github.com/ge0rg/libmpq'

  def patches
    # fixes autogen.sh (glibtoolize instead of libtoolize)
    DATA
  end

  def install
    system "sh ./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end

__END__
--- a/autogen.sh
+++ b/autogen.sh
@@ -8,7 +8,7 @@ directory=`dirname $0`
 touch $directory/configure.ac
 
 # Regenerate configuration files
-libtoolize --copy
+glibtoolize --copy
 aclocal
 autoheader
 automake --foreign --add-missing --copy
-- 
