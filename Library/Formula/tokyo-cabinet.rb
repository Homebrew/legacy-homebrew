require 'formula'

class TokyoCabinetJava <Formula
  url 'http://www.1978th.net/tokyocabinet/javapkg/tokyocabinet-java-1.24.tar.gz'
  homepage 'http://fallabs.com/tokyocabinet/'
  md5 'cb7db713865cedf255916691daa522d2'

  def patches
    # As of Java update 3 for 10.6 apple seems to include stuff like headers we
    # need (jni.h) in a separate Java developer package. This package installs
    # the headers to /System/Library/Frameworks/JavaVM.framework/Headers.
    if not File.directory? '/System/Library/Frameworks/JavaVM.framework/Home/include'
      DATA
    end
  end
end

class TokyoCabinet <Formula
  url 'http://fallabs.com/tokyocabinet/tokyocabinet-1.4.46.tar.gz'
  homepage 'http://fallabs.com/tokyocabinet/'
  md5 '341dadd1f3d68760e350f7e731111786'

  def options
    [["--without-java", "Do not build and install Java bindings"]]
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-fastest"
    system "make"
    system "make install"

    if not ARGV.include? "--without-java"
      TokyoCabinetJava.new.brew do
        if not File.directory? "/System/Library/Frameworks/JavaVM.framework/Home"
          onoe "I can't find Java. Please install a JDK. Right now I only know
       how to find Apple's version, so either install that one or fix this
       formula to support other JDKs."
           exit 1
        end
        ENV["MYJAVAHOME"] = "/System/Library/Frameworks/JavaVM.framework/Home"

        if not File.exist? "/System/Library/Frameworks/JavaVM.framework/Home/include/jni.h" and
           not File.exist? "/System/Library/Frameworks/JavaVM.framework/Headers/jni.h"
          onoe "I cannot find jni.h. Maybe you need to install something like
       \"Java for Mac OS X 10.6 Update 3 Developer Package\"? To find it, log
       in to connect.apple.com and look under Downloads -> Java."
           exit 1
        end

        ENV.append "CPPFLAGS", "-I#{include}"
        ENV.append "LDFLAGS", "-L#{lib}"
        system "./configure", "--prefix=#{prefix}"
        system "make INCLUDEDIR=#{include} LIBDIR=#{lib}"
        system "make check"
        system "make install"
      end
    end
  end
end

__END__
diff -Naur configure.orig configure
--- old/configure      2010-09-20 01:11:11.000000000 +0200
+++ new/configure   2010-10-26 18:16:09.000000000 +0200
@@ -2062,6 +2062,8 @@
 if uname | grep Darwin > /dev/null
 then
   JVMPLATFORM="mac"
+  MYCPPFLAGS="$MYCPPFLAGS -I/System/Library/Frameworks/JavaVM.framework/Headers"
+  CPATH="$MYCPATH:/System/Library/Frameworks/JavaVM.framework/Headers"
 else
   for file in `\ls $MYJAVAHOME/include`
   do
