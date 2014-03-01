require 'formula'

class Ruby < Formula
  homepage 'https://www.ruby-lang.org/'
  url 'http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.1.tar.bz2'
  sha256 '96aabab4dd4a2e57dd0d28052650e6fcdc8f133fa8980d9b936814b1e93f6cfc'

  head do
    url 'http://svn.ruby-lang.org/repos/ruby/trunk/'
    depends_on :autoconf
  end

  option :universal
  option 'with-suffix', 'Suffix commands with "21"'
  option 'with-doc', 'Install documentation'
  option 'with-tcltk', 'Install with Tcl/Tk support'

  depends_on 'pkg-config' => :build
  depends_on 'readline' => :recommended
  depends_on 'gdbm' => :optional
  depends_on 'gmp' => :optional
  depends_on 'libffi' => :optional
  depends_on 'libyaml'
  depends_on 'openssl'
  depends_on :x11 if build.with? 'tcltk'

  fails_with :llvm do
    build 2326
  end

  # pthread_setname_np() is unavailable before Snow Leopard
  # Reported upstream: https://bugs.ruby-lang.org/issues/9492
  def patches; DATA; end if MacOS.version < :snow_leopard

  def install
    system "autoconf" if build.head?

    args = %W[--prefix=#{prefix} --enable-shared --disable-silent-rules]
    args << "--program-suffix=21" if build.with? "suffix"
    args << "--with-arch=#{Hardware::CPU.universal_archs.join(',')}" if build.universal?
    args << "--with-out-ext=tk" unless build.with? "tcltk"
    args << "--disable-install-doc" unless build.with? "doc"
    args << "--disable-dtrace" unless MacOS::CLT.installed?

    paths = [
      Formula["libyaml"].opt_prefix,
      Formula["openssl"].opt_prefix
    ]

    %w[readline gdbm gmp libffi].each { |dep|
      paths << Formula[dep].opt_prefix if build.with? dep
    }

    args << "--with-opt-dir=#{paths.join(":")}"

    # Put gem, site and vendor folders in the HOMEBREW_PREFIX
    ruby_lib = HOMEBREW_PREFIX/"lib/ruby"
    (ruby_lib/'site_ruby').mkpath
    (ruby_lib/'vendor_ruby').mkpath
    (ruby_lib/'gems').mkpath

    (lib/'ruby').install_symlink ruby_lib/'site_ruby',
                                 ruby_lib/'vendor_ruby',
                                 ruby_lib/'gems'

    system "./configure", *args
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    By default, gem installed executables will be placed into:
      #{opt_prefix}/bin

    You may want to add this to your PATH. After upgrades, you can run
      gem pristine --all --only-executables

    to restore binstubs for installed gems.
    EOS
  end
end

__END__
diff --git a/thread_pthread.c b/thread_pthread.c
index 3911f8f..74d1ab7 100644
--- a/thread_pthread.c
+++ b/thread_pthread.c
@@ -1416,15 +1416,6 @@ timer_thread_sleep(rb_global_vm_lock_t* unused)
 }
 #endif /* USE_SLEEPY_TIMER_THREAD */
 
-#if defined(__linux__) && defined(PR_SET_NAME)
-# define SET_THREAD_NAME(name) prctl(PR_SET_NAME, name)
-#elif defined(__APPLE__)
-/* pthread_setname_np() on Darwin does not have target thread argument */
-# define SET_THREAD_NAME(name) pthread_setname_np(name)
-#else
-# define SET_THREAD_NAME(name) (void)0
-#endif
-
 static void *
 thread_timer(void *p)
 {
@@ -1432,7 +1423,9 @@ thread_timer(void *p)
 
     if (TT_DEBUG) WRITE_CONST(2, "start timer thread\n");
 
-    SET_THREAD_NAME("ruby-timer-thr");
+#if defined(__linux__) && defined(PR_SET_NAME)
+    prctl(PR_SET_NAME, "ruby-timer-thr");
+#endif
 
 #if !USE_SLEEPY_TIMER_THREAD
     native_mutex_initialize(&timer_thread_lock);
