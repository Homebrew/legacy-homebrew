require 'formula'

class Libmp3splt < Formula
  url 'http://downloads.sourceforge.net/project/mp3splt/libmp3splt/0.7.1/libmp3splt-0.7.1.tar.gz'
  homepage 'http://mp3splt.sourceforge.net'
  md5 '62025951f483334f14f1b9be58162094'

  depends_on 'pkg-config' => :build
  depends_on 'automake' => :build
  depends_on 'gettext'
  depends_on 'pcre'
  depends_on 'libid3tag'
  depends_on 'mad'
  depends_on 'libvorbis'

  def patches
    DATA
  end

  def install
    if !(MacOS.version >= 10.7)
      system "./autogen.sh"
      system "autoconf"
    end
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/autogen.sh b/autogen.sh
index 68962f2..916b868 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -53,7 +53,7 @@ echo -n "1/6 Running autopoint... " \
 && echo -n "3/6 Running autoheader... " \
 && autoheader && echo "done" \
 && echo -n "4/6 Running libtoolize... " \
-&& libtoolize -c --force && echo "done" \
+&& glibtoolize -c --force && echo "done" \
 && echo -n "5/6 Running autoconf... " \
 && autoconf && echo "done" \
 && echo -n "6/6 Running automake... " \
