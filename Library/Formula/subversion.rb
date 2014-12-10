require "formula"

class Subversion < Formula
  homepage "https://subversion.apache.org/"
  url "http://www.apache.org/dyn/closer.cgi?path=subversion/subversion-1.8.10.tar.bz2"
  mirror "http://archive.apache.org/dist/subversion/subversion-1.8.10.tar.bz2"
  sha1 "d6896d94bb53c1b4c6e9c5bb1a5c466477b19b2b"
  revision 2

  bottle do
    sha1 "fea8a67fd177ba418c9185423d4ce8055d8f2ef5" => :yosemite
    sha1 "ab3d546951f17ce2f2159a4e6bbf0c10b0c6a4c0" => :mavericks
    sha1 "18a00000ae92b6b6bad79f3b84f0ffcba4e655f7" => :mountain_lion
  end

  deprecated_option "java" => "with-java"
  deprecated_option "perl" => "with-perl"
  deprecated_option "ruby" => "with-ruby"

  option :universal
  option "with-java", "Build Java bindings"
  option "with-perl", "Build Perl bindings"
  option "with-ruby", "Build Ruby bindings"
  option "with-gpg-agent", "Build with support for GPG Agent"

  resource "serf" do
    url "https://serf.googlecode.com/svn/src_releases/serf-1.3.7.tar.bz2", :using => :curl
    sha1 "db9ae339dba10a2b47f9bdacf30a58fd8e36683a"
  end

  depends_on "pkg-config" => :build
  depends_on :apr => :build

  # Always build against Homebrew versions instead of system versions for consistency.
  depends_on "sqlite"
  depends_on :python => :optional

  # Bindings require swig
  depends_on "swig" if build.with? "perl" or build.with? "python" or build.with? "ruby"

  # For Serf
  depends_on "scons" => :build
  depends_on "openssl"

  # Other optional dependencies
  depends_on "gpg-agent" => :optional

  # Fix #23993 by stripping flags swig can't handle from SWIG_CPPFLAGS
  # Prevent "-arch ppc" from being pulled in from Perl's $Config{ccflags}
  patch :DATA

  if build.with? "perl" or build.with? "ruby"
    # If building bindings, allow non-system interpreters
    # Currently the serf -> scons dependency forces stdenv, so this isn't
    # strictly necessary
    env :userpaths

    # When building Perl or Ruby bindings, need to use a compiler that
    # recognizes GCC-style switches, since that's what the system languages
    # were compiled against.
    fails_with :clang do
      build 318
      cause "core.c:1: error: bad value (native) for -march= switch"
    end
  end

  def install
    serf_prefix = libexec+"serf"

    resource("serf").stage do
      # SConstruct merges in gssapi linkflags using scons's MergeFlags,
      # but that discards duplicate values - including the duplicate
      # values we want, like multiple -arch values for a universal build.
      # Passing 0 as the `unique` kwarg turns this behaviour off.
      inreplace "SConstruct", "unique=1", "unique=0"

      ENV.universal_binary if build.universal?
      # scons ignores our compiler and flags unless explicitly passed
      args = %W[PREFIX=#{serf_prefix} GSSAPI=/usr CC=#{ENV.cc}
                CFLAGS=#{ENV.cflags} LINKFLAGS=#{ENV.ldflags}
                OPENSSL=#{Formula["openssl"].opt_prefix}]
      scons *args
      scons "install"
    end

    if build.include? "unicode-path"
      raise <<-EOS.undent
        The --unicode-path patch is not supported on Subversion 1.8.

        Upgrading from a 1.7 version built with this patch is not supported.

        You should stay on 1.7, install 1.7 from homebrew-versions, or
          brew rm subversion && brew install subversion
        to build a new version of 1.8 without this patch.
      EOS
    end

    if build.with? "java"
      # Java support doesn't build correctly in parallel:
      # https://github.com/Homebrew/homebrew/issues/20415
      ENV.deparallelize

      unless build.universal?
        opoo "A non-Universal Java build was requested."
        puts <<-EOS.undent
        To use Java bindings with various Java IDEs, you might need a universal build:
          `brew install subversion --universal --java`
        EOS
      end

      if ENV["JAVA_HOME"]
        opoo "JAVA_HOME is set. Try unsetting it if JNI headers cannot be found."
      end
    end

    ENV.universal_binary if build.universal?

    # Use existing system zlib
    # Use dep-provided other libraries
    # Don't mess with Apache modules (since we're not sudo)
    args = ["--disable-debug",
            "--prefix=#{prefix}",
            "--with-apr=#{which("apr-1-config").dirname}",
            "--with-zlib=/usr",
            "--with-sqlite=#{Formula["sqlite"].opt_prefix}",
            "--with-serf=#{serf_prefix}",
            "--disable-mod-activation",
            "--disable-nls",
            "--without-apache-libexecdir",
            "--without-berkeley-db"]

    args << "--enable-javahl" << "--without-jikes" if build.with? "java"
    args << "--without-gpg-agent" if build.without? "gpg-agent"

    if build.with? "ruby"
      args << "--with-ruby-sitedir=#{lib}/ruby"
      # Peg to system Ruby
      args << "RUBY=/usr/bin/ruby"
    end

    # The system Python is built with llvm-gcc, so we override this
    # variable to prevent failures due to incompatible CFLAGS
    ENV["ac_cv_python_compile"] = ENV.cc

    inreplace "Makefile.in",
              "toolsdir = @bindir@/svn-tools",
              "toolsdir = @libexecdir@/svn-tools"

    system "./configure", *args
    system "make"
    system "make", "install"
    bash_completion.install "tools/client-side/bash_completion" => "subversion"

    system "make", "tools"
    system "make", "install-tools"

    if build.with? "python"
      system "make", "swig-py"
      system "make", "install-swig-py"
    end

    if build.with? "perl"
      # In theory SWIG can be built in parallel, in practice...
      ENV.deparallelize
      # Remove hard-coded ppc target, add appropriate ones
      if build.universal?
        arches = Hardware::CPU.universal_archs.as_arch_flags
      elsif MacOS.version <= :leopard
        arches = "-arch #{Hardware::CPU.arch_32_bit}"
      else
        arches = "-arch #{Hardware::CPU.arch_64_bit}"
      end

      perl_core = Pathname.new(`perl -MConfig -e 'print $Config{archlib}'`)+'CORE'
      unless perl_core.exist?
        onoe "perl CORE directory does not exist in '#{perl_core}'"
      end

      inreplace "Makefile" do |s|
        s.change_make_var! "SWIG_PL_INCLUDES",
          "$(SWIG_INCLUDES) #{arches} -g -pipe -fno-common -DPERL_DARWIN -fno-strict-aliasing -I/usr/local/include -I#{perl_core}"
      end
      system "make", "swig-pl"
      system "make", "install-swig-pl", "DESTDIR=#{prefix}"

      # Some of the libraries get installed into the wrong place, they end up having the
      # prefix in the directory name twice.

      lib.install Dir["#{prefix}/#{lib}/*"]
    end

    if build.with? "java"
      system "make", "javahl"
      system "make", "install-javahl"
    end

    if build.with? "ruby"
      # Peg to system Ruby
      system "make", "swig-rb", "EXTRA_SWIG_LDFLAGS=-L/usr/lib"
      system "make", "install-swig-rb"
    end
  end

  test do
    system "#{bin}/svnadmin", "create", "test"
    system "#{bin}/svnadmin", "verify", "test"
  end

  def caveats
    s = <<-EOS.undent
      svntools have been installed to:
        #{opt_libexec}
    EOS

    if build.with? "perl"
      s += <<-EOS.undent

        The perl bindings are located in various subdirectories of:
          #{prefix}/Library/Perl
      EOS
    end

    if build.with? "ruby"
      s += <<-EOS.undent

        You may need to add the Ruby bindings to your RUBYLIB from:
          #{HOMEBREW_PREFIX}/lib/ruby
      EOS
    end

    if build.with? "java"
      s += <<-EOS.undent

        You may need to link the Java bindings into the Java Extensions folder:
          sudo mkdir -p /Library/Java/Extensions
          sudo ln -s #{HOMEBREW_PREFIX}/lib/libsvnjavahl-1.dylib /Library/Java/Extensions/libsvnjavahl-1.dylib
      EOS
    end

    return s.empty? ? nil : s
  end
end

__END__
diff --git a/configure b/configure
index 445251b..6ff4332 100755
--- a/configure
+++ b/configure
@@ -10348,7 +10348,7 @@ $as_echo "$lt_cv_ld_force_load" >&6; }
       case ${MACOSX_DEPLOYMENT_TARGET-10.0},$host in
 	10.0,*86*-darwin8*|10.0,*-darwin[91]*)
 	  _lt_dar_allow_undefined='${wl}-undefined ${wl}dynamic_lookup' ;;
-	10.[012]*)
+	10.[012][,.]*)
 	  _lt_dar_allow_undefined='${wl}-flat_namespace ${wl}-undefined ${wl}suppress' ;;
 	10.*)
 	  _lt_dar_allow_undefined='${wl}-undefined ${wl}dynamic_lookup' ;;
@@ -25205,6 +25205,8 @@ fi
 SWIG_CPPFLAGS="$CPPFLAGS"
 
   SWIG_CPPFLAGS=`echo "$SWIG_CPPFLAGS" | $SED -e 's/-no-cpp-precomp //'`
+  SWIG_CPPFLAGS=`echo "$SWIG_CPPFLAGS" | $SED -e 's/-F\/[^ ]* //'`
+  SWIG_CPPFLAGS=`echo "$SWIG_CPPFLAGS" | $SED -e 's/-isystem\/[^ ]* //'`
 
 
 
diff --git a/subversion/bindings/swig/perl/native/Makefile.PL.in b/subversion/bindings/swig/perl/native/Makefile.PL.in
index a60430b..bd9b017 100644
--- a/subversion/bindings/swig/perl/native/Makefile.PL.in
+++ b/subversion/bindings/swig/perl/native/Makefile.PL.in
@@ -76,10 +76,13 @@ my $apr_ldflags = '@SVN_APR_LIBS@'
 
 chomp $apr_shlib_path_var;
 
+my $config_ccflags = $Config{ccflags};
+$config_ccflags =~ s/-arch\s+\S+//g;
+
 my %config = (
     ABSTRACT => 'Perl bindings for Subversion',
     DEFINE => $cppflags,
-    CCFLAGS => join(' ', $cflags, $Config{ccflags}),
+    CCFLAGS => join(' ', $cflags, $config_ccflags),
     INC  => join(' ', $includes, $cppflags,
                  " -I$swig_srcdir/perl/libsvn_swig_perl",
                  " -I$svnlib_srcdir/include",
