require 'formula'

class Ruby < Formula
  homepage 'https://www.ruby-lang.org/'
  revision 1

  stable do
    url "http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.1.tar.bz2"
    sha256 "96aabab4dd4a2e57dd0d28052650e6fcdc8f133fa8980d9b936814b1e93f6cfc"

    # Combination of patches from trunk to fix build against readline 6.3
    patch :DATA
  end

  bottle do
    sha1 "ca1a24ea84766ad60d736242fe9c09fa20bcb751" => :mavericks
    sha1 "f00a62a246a3b391ac9f8a80d5b1b774ba54a324" => :mountain_lion
    sha1 "037357e4b75e55425789a918179f719657bba340" => :lion
  end

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

  def install
    system "autoconf" if build.head?

    args = %W[--prefix=#{prefix} --enable-shared --disable-silent-rules]
    args << "--program-suffix=21" if build.with? "suffix"
    args << "--with-arch=#{Hardware::CPU.universal_archs.join(',')}" if build.universal?
    args << "--with-out-ext=tk" if build.without? "tcltk"
    args << "--disable-install-doc" if build.without? "doc"
    args << "--disable-dtrace" unless MacOS::CLT.installed?
    args << "--without-gmp" if build.without? "gmp"

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
      #{opt_bin}

    You may want to add this to your PATH. After upgrades, you can run
      gem pristine --all --only-executables

    to restore binstubs for installed gems.
    EOS
  end

  test do
    output = `#{bin}/ruby -e 'puts "hello"'`
    assert_equal "hello\n", output
    assert_equal 0, $?.exitstatus
  end
end

__END__
diff --git a/ext/readline/extconf.rb b/ext/readline/extconf.rb
index 0b121c1..3317e2f 100644
--- a/ext/readline/extconf.rb
+++ b/ext/readline/extconf.rb
@@ -19,6 +19,10 @@ def readline.have_func(func)
   return super(func, headers)
 end
 
+def readline.have_type(type)
+  return super(type, headers)
+end
+
 dir_config('curses')
 dir_config('ncurses')
 dir_config('termcap')
@@ -94,4 +98,11 @@ def readline.have_func(func)
 readline.have_func("rl_redisplay")
 readline.have_func("rl_insert_text")
 readline.have_func("rl_delete_text")
+unless readline.have_type("rl_hook_func_t*")
+  # rl_hook_func_t is available since readline-4.2 (2001).
+  # Function is removed at readline-6.3 (2014).
+  # However, editline (NetBSD 6.1.3, 2014) doesn't have rl_hook_func_t.
+  $defs << "-Drl_hook_func_t=Function"
+end
+
 create_makefile("readline")
diff --git a/ext/readline/readline.c b/ext/readline/readline.c
index 659adb9..7bc0eed 100644
--- a/ext/readline/readline.c
+++ b/ext/readline/readline.c
@@ -1974,7 +1974,7 @@ Init_readline()
 
     rl_attempted_completion_function = readline_attempted_completion_function;
 #if defined(HAVE_RL_PRE_INPUT_HOOK)
-    rl_pre_input_hook = (Function *)readline_pre_input_hook;
+    rl_pre_input_hook = (rl_hook_func_t *)readline_pre_input_hook;
 #endif
 #ifdef HAVE_RL_CATCH_SIGNALS
     rl_catch_signals = 0;
