require 'formula'

class BerkeleyDb < Formula
  homepage 'http://www.oracle.com/technology/products/berkeley-db/index.html'
  url 'http://download.oracle.com/berkeley-db/db-5.3.28.tar.gz'
  sha1 'fa3f8a41ad5101f43d08bc0efb6241c9b6fc1ae9'

  bottle do
    cellar :any
    revision 1
    sha1 "a134b5effaa73fd296b2601180520292c0a6d095" => :yosemite
    sha1 "910660e253bf32a1ce730d4ba27e3090f645f5f6" => :mavericks
    sha1 "aaafa41026335a6b7e6c0792d1511325c79409fa" => :mountain_lion
  end

  option 'with-java', 'Compile with Java support.'
  option 'enable-sql', 'Compile with SQL support.'

  # Fix build under Xcode 4.6
  # Double-underscore names are reserved, and __atomic_compare_exchange is now
  # a built-in, so rename this to something non-conflicting.
  patch :DATA

  def install
    # BerkeleyDB dislikes parallel builds
    ENV.deparallelize
    # --enable-compat185 is necessary because our build shadows
    # the system berkeley db 1.x
    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --mandir=#{man}
      --enable-cxx
      --enable-compat185
    ]

    if build.with? "java"
      java_home = ENV["JAVA_HOME"] = `/usr/libexec/java_home`.chomp

      # The Oracle JDK puts jni.h into #{java_home}/include and jni_md.h into
      # #{java_home}/include/darwin.  The original Apple/SUN JDK placed jni.h
      # and jni_md.h into
      # /System/Library/Frameworks/JavaVM.framework/Versions/Current/Headers/
      #
      # Setup the include path with the Oracle JDK location first and the Apple JDK location second.
      ENV["CFLAGS"] = "-I#{java_home}/include" <<
                      " -I#{java_home}/include/darwin" <<
                      " -I/System/Library/Frameworks/JavaVM.framework/Versions/Current/Headers/"
    end
    args << "--enable-java" if build.with? "java"
    args << "--enable-sql" if build.include? "enable-sql"

    # BerkeleyDB requires you to build everything from the build_unix subdirectory
    cd 'build_unix' do
      system "../dist/configure", *args
      system "make install"

      # use the standard docs location
      doc.parent.mkpath
      mv prefix/'docs', doc
    end
  end
end

__END__
diff -r -c -N ../db-5.3.28.orig/lang/java/src/com/sleepycat/asm/ClassReader.java ./lang/java/src/com/sleepycat/asm/ClassReader.java
*** ../db-5.3.28.orig/lang/java/src/com/sleepycat/asm/ClassReader.java	2013-09-09 13:05:04.000000000 -0230
--- ./lang/java/src/com/sleepycat/asm/ClassReader.java	2015-02-20 15:34:50.000000000 -0330
***************
*** 163,169 ****
      public ClassReader(final byte[] b, final int off, final int len) {
          this.b = b;
          // checks the class version
!         if (readShort(6) > Opcodes.V1_7) {
              throw new IllegalArgumentException();
          }
          // parses the constant pool
--- 163,169 ----
      public ClassReader(final byte[] b, final int off, final int len) {
          this.b = b;
          // checks the class version
!         if (readShort(6) > Opcodes.V1_8) {
              throw new IllegalArgumentException();
          }
          // parses the constant pool
diff -r -c -N ../db-5.3.28.orig/lang/java/src/com/sleepycat/asm/Opcodes.java ./lang/java/src/com/sleepycat/asm/Opcodes.java
*** ../db-5.3.28.orig/lang/java/src/com/sleepycat/asm/Opcodes.java	2013-09-09 13:05:04.000000000 -0230
--- ./lang/java/src/com/sleepycat/asm/Opcodes.java	2015-02-20 15:35:09.000000000 -0330
***************
*** 56,61 ****
--- 56,62 ----
      int V1_5 = 0 << 16 | 49;
      int V1_6 = 0 << 16 | 50;
      int V1_7 = 0 << 16 | 51;
+     int V1_8 = 0 << 16 | 52;
  
      // access flags
  
diff -r -c -N ../db-5.3.28.orig/src/dbinc/atomic.h ./src/dbinc/atomic.h
*** ../db-5.3.28.orig/src/dbinc/atomic.h	2013-09-09 13:05:08.000000000 -0230
--- ./src/dbinc/atomic.h	2015-02-20 15:33:31.000000000 -0330
***************
*** 144,150 ****
  #define	atomic_inc(env, p)	__atomic_inc(p)
  #define	atomic_dec(env, p)	__atomic_dec(p)
  #define	atomic_compare_exchange(env, p, o, n)	\
! 	__atomic_compare_exchange((p), (o), (n))
  static inline int __atomic_inc(db_atomic_t *p)
  {
  	int	temp;
--- 144,150 ----
  #define	atomic_inc(env, p)	__atomic_inc(p)
  #define	atomic_dec(env, p)	__atomic_dec(p)
  #define	atomic_compare_exchange(env, p, o, n)	\
! 	__atomic_compare_exchange_db((p), (o), (n))
  static inline int __atomic_inc(db_atomic_t *p)
  {
  	int	temp;
***************
*** 176,182 ****
   * http://gcc.gnu.org/onlinedocs/gcc-4.1.0/gcc/Atomic-Builtins.html
   * which configure could be changed to use.
   */
! static inline int __atomic_compare_exchange(
  	db_atomic_t *p, atomic_value_t oldval, atomic_value_t newval)
  {
  	atomic_value_t was;
--- 176,182 ----
   * http://gcc.gnu.org/onlinedocs/gcc-4.1.0/gcc/Atomic-Builtins.html
   * which configure could be changed to use.
   */
! static inline int __atomic_compare_exchange_db(
  	db_atomic_t *p, atomic_value_t oldval, atomic_value_t newval)
  {
  	atomic_value_t was;
