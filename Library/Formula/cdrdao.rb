require 'formula'

class Cdrdao < Formula
  homepage 'http://cdrdao.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/cdrdao/cdrdao/1.2.3/cdrdao-1.2.3.tar.bz2'
  sha1 '70d6547795a1342631c7ab56709fd1940c2aff9f'

  depends_on 'pkg-config' => :build
  depends_on 'libao'
  depends_on 'libvorbis'
  depends_on 'mad'
  depends_on 'lame'

  fails_with :llvm do
    build 2326
    cause "Segfault while linking"
  end

  # first patch fixes build problems under 10.6
  # see http://sourceforge.net/tracker/index.php?func=detail&aid=2981804&group_id=2171&atid=302171
  patch do
    url "http://sourceforge.net/tracker/download.php?group_id=2171&atid=302171&file_id=369387&aid=2981804"
    sha1 "1c0663d13d0f0b7ebbb281f69751eff0afed7c8c"
  end

  # second patch fixes device autodetection on OS X
  # see http://trac.macports.org/ticket/27819
  # upstream bug report:
  # http://sourceforge.net/tracker/?func=detail&aid=3381672&group_id=2171&atid=102171
  patch :p0, :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end

__END__
--- dao/main.cc	2013-11-26 12:00:00.000000000 -0400
+++ dao/main.cc	2013-11-26 12:00:00.000000000 -0400
@@ -1242,7 +1242,7 @@
 const char* getDefaultDevice(DaoDeviceType req)
 {
     int i, len;
-    static char buf[128];
+    static char buf[1024];
 
     // This function should not be called if the command issues
     // doesn't actually require a device.
@@ -1270,7 +1270,7 @@
 	    if (req == NEED_CDRW_W && !rww)
 	      continue;
 
-	    strncpy(buf, sdata[i].dev.c_str(), 128);
+	    strncpy(buf, sdata[i].dev.c_str(), 1024);
 	    delete[] sdata;
 	    return buf;
 	}
