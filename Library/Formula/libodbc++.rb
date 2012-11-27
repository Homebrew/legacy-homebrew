require 'formula'

class Libodbcxx < Formula
  homepage 'http://libodbcxx.sourceforge.net'
  url 'http://sourceforge.net/projects/libodbcxx/files/libodbc++/0.2.5/libodbc++-0.2.5.tar.gz'

  sha1 'e59842266b981caab24a6fae1f7d48b6799420f8'
  
  def patches
    # Fixes a compilation error on 64bit machines.
    # Submitted a patch to the upstream project:
    #   http://sourceforge.net/tracker/?func=detail&aid=3590196&group_id=19075&atid=319075
    DATA
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install" # if this fails, try separate make/make install steps
  end
end

__END__
diff --git a/src/dtconv.h b/src/dtconv.h
index b281ec5..18a04da 100644
--- a/src/dtconv.h
+++ b/src/dtconv.h
@@ -113,7 +113,7 @@ namespace odbc {
     snprintf(buf,LONG_STR_LEN,
 # endif
 # if defined(PRId64)
-             ODBCXX_STRING_PERCENT PRId64
+             "%" PRId64
 # elif ODBCXX_SIZEOF_LONG==8
              ODBCXX_STRING_CONST("%ld")
 # else
