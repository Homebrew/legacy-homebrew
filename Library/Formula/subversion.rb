require 'formula'

class Subversion < Formula
  homepage 'http://subversion.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=subversion/subversion-1.8.5.tar.bz2'
  mirror 'http://archive.apache.org/dist/subversion/subversion-1.8.5.tar.bz2'
  sha1 'd21de7daf37d9dd1cb0f777e999a529b96f83082'

  bottle do
    sha1 '1022095a741a6fb2c43b28003cecd6d8f220fe1e' => :mavericks
    sha1 '82f6a8eb37d89badd9ed77ee7620f84304278db7' => :mountain_lion
    sha1 '00340eabc7849c05ec0611ae8aea79db3848578e' => :lion
  end

  option :universal
  option 'with-brewed-openssl', 'Include OpenSSL support to Serf via Homebrew'
  option 'java', 'Build Java bindings'
  option 'perl', 'Build Perl bindings'
  option 'ruby', 'Build Ruby bindings'

  resource 'serf' do
    url 'http://serf.googlecode.com/svn/src_releases/serf-1.3.4.tar.bz2', :using => :curl
    sha1 'eafc8317d7a9c77d4db9ce1e5c71a33822f57c3a'
  end

  depends_on 'pkg-config' => :build

  # Always build against Homebrew versions instead of system versions for consistency.
  depends_on 'sqlite'
  depends_on :python => :optional

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool

  # Bindings require swig
  depends_on 'swig' if build.include? 'perl' or build.with? 'python' or build.include? 'ruby'

  # For Serf
  depends_on 'scons' => :build
  depends_on 'openssl' if build.with? 'brewed-openssl'

  # If building bindings, allow non-system interpreters
  env :userpaths if build.include? 'perl' or build.include? 'ruby'

  # 1. Prevent '-arch ppc' from being pulled in from Perl's $Config{ccflags}
  # 2. Backport r1535610 to help fix #23993.
  #    See http://subversion.tigris.org/issues/show_bug.cgi?id=4465
  # 3. Fix #23993 by stripping flags swig can't handle from SWIG_CPPFLAGS
  def patches
    { :p0 => DATA }
  end

  # When building Perl or Ruby bindings, need to use a compiler that
  # recognizes GCC-style switches, since that's what the system languages
  # were compiled against.
  fails_with :clang do
    build 318
    cause "core.c:1: error: bad value (native) for -march= switch"
  end if build.include? 'perl' or build.include? 'ruby'

  def apr_bin
    Superenv.bin or "/usr/bin"
  end

  def install
    serf_prefix = libexec+'serf'

    resource('serf').stage do
      # SConstruct merges in gssapi linkflags using scons's MergeFlags,
      # but that discards duplicate values - including the duplicate
      # values we want, like multiple -arch values for a universal build.
      # Passing 0 as the `unique` kwarg turns this behaviour off.
      inreplace 'SConstruct', 'unique=1', 'unique=0'

      ENV.universal_binary if build.universal?
      # scons ignores our compiler and flags unless explicitly passed
      args = %W[PREFIX=#{serf_prefix} GSSAPI=/usr CC=#{ENV.cc}
                CFLAGS=#{ENV.cflags} LINKFLAGS=#{ENV.ldflags}]
      args << "OPENSSL=#{Formula.factory('openssl').opt_prefix}" if build.with? 'brewed-openssl'
      scons *args
      scons "install"
    end

    if build.include? 'unicode-path'
      raise Homebrew::InstallationError.new(self, <<-EOS.undent
        The --unicode-path patch is not supported on Subversion 1.8.

        Upgrading from a 1.7 version built with this patch is not supported.

        You should stay on 1.7, install 1.7 from homebrew-versions, or
          brew rm subversion && brew install subversion
        to build a new version of 1.8 without this patch.
      EOS
      )
    end

    if build.include? 'java'
      # Java support doesn't build correctly in parallel:
      # https://github.com/Homebrew/homebrew/issues/20415
      ENV.deparallelize

      unless build.universal?
        opoo "A non-Universal Java build was requested."
        puts "To use Java bindings with various Java IDEs, you might need a universal build:"
        puts "  brew install subversion --universal --java"
      end

      ENV.fetch('JAVA_HOME') do
        opoo "JAVA_HOME is set. Try unsetting it if JNI headers cannot be found."
      end
    end

    ENV.universal_binary if build.universal?

    # Use existing system zlib
    # Use dep-provided other libraries
    # Don't mess with Apache modules (since we're not sudo)
    args = ["--disable-debug",
            "--prefix=#{prefix}",
            "--with-apr=#{apr_bin}",
            "--with-zlib=/usr",
            "--with-sqlite=#{Formula.factory('sqlite').opt_prefix}",
            "--with-serf=#{serf_prefix}",
            "--disable-mod-activation",
            "--disable-nls",
            "--without-apache-libexecdir",
            "--without-berkeley-db"]

    args << "--enable-javahl" << "--without-jikes" if build.include? 'java'

    if build.include? 'ruby'
      args << "--with-ruby-sitedir=#{lib}/ruby"
      # Peg to system Ruby
      args << "RUBY=/usr/bin/ruby"
    end

    # The system Python is built with llvm-gcc, so we override this
    # variable to prevent failures due to incompatible CFLAGS
    ENV['ac_cv_python_compile'] = ENV.cc

    inreplace 'Makefile.in',
              'toolsdir = @bindir@/svn-tools',
              'toolsdir = @libexecdir@/svn-tools'
    # Suggestion by upstream. http://svn.haxx.se/users/archive-2013-09/0188.shtml
    system "./autogen.sh"
    system "./configure", *args
    system "make"
    system "make install"
    bash_completion.install 'tools/client-side/bash_completion' => 'subversion'

    system "make tools"
    system "make install-tools"

    if build.with? 'python'
      system "make swig-py"
      system "make install-swig-py"
    end

    if build.include? 'perl'
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
      system "make swig-pl"
      system "make", "install-swig-pl", "DESTDIR=#{prefix}"
      # Some of the libraries get installed into the wrong place, they end up having the
      # prefix in the directory name twice.
      mv Dir.glob("#{prefix}/#{lib}/*"), "#{lib}"
    end

    if build.include? 'java'
      system "make javahl"
      system "make install-javahl"
    end

    if build.include? 'ruby'
      # Peg to system Ruby
      system "make swig-rb EXTRA_SWIG_LDFLAGS=-L/usr/lib"
      system "make install-swig-rb"
    end
  end

  test do
    system "#{bin}/svnadmin", 'create', 'test'
    system "#{bin}/svnadmin", 'verify', 'test'
  end

  def caveats
    s = <<-EOS.undent
      svntools have been installed to:
        #{opt_prefix}/libexec
    EOS

    if build.include? 'perl'
      s += <<-EOS.undent

        The perl bindings are located in various subdirectories of:
          #{prefix}/Library/Perl
      EOS
    end

    if build.include? 'ruby'
      s += <<-EOS.undent

        You may need to add the Ruby bindings to your RUBYLIB from:
          #{HOMEBREW_PREFIX}/lib/ruby
      EOS
    end

    if build.include? 'java'
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

Patch 1

--- subversion/bindings/swig/perl/native/Makefile.PL.in~ 2013-06-20 18:58:55.000000000 +0200
+++ subversion/bindings/swig/perl/native/Makefile.PL.in	2013-06-20 19:00:49.000000000 +0200
@@ -69,10 +69,15 @@

 chomp $apr_shlib_path_var;

+my $config_ccflags = $Config{ccflags};
+# remove any -arch arguments, since those
+# we want will already be in $cflags
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

Patch 2

$  svn log -v -r1535610 --diff http://svn.apache.org/repos/asf/subversion/trunk
------------------------------------------------------------------------
r1535610 | breser | 2013-10-24 20:22:50 -0600 (Thu, 24 Oct 2013) | 20 lines
Changed paths:
   M /subversion/trunk/Makefile.in
   M /subversion/trunk/build.conf
   M /subversion/trunk/configure.ac

Filter out -no-cpp-precomp from flags passed to SWIG.

This is necessary since APR for whatever reason leaks the fact that it uses
-no-cpp-precomp on OS X into apr-1-config.  Unfortunately, a lot of versions
of APR have this in the wild so we just have to deal with it.  If you use clang
directly you don't see this because we already filter it out of CPPFLAGS.

* Makefile.in
  (SWIG_CPPFLAGS): New variable, deliberately pulling in EXTRA_CPPFLAGS and
    not EXTRA_SIWG_CPPFLAGS because it would be harmful to split those
    (e.g. users wanting to enable a feature that adds an API).

* build.conf
  (swig-python-opts, swig-perl-opts, swig-ruby-opts): Use SWIG_CPPFLAGS
    instead of CPPFLAGS.

* configure.acc
  (SWIG_CPPFLAGS): Add the variable and copy it from the normal CPPFLAGS
    while filtering out the -no-cpp-precomp.


Index: Makefile.in
===================================================================
--- Makefile.in	(revision 1535609)
+++ Makefile.in	(revision 1535610)
@@ -181,6 +181,7 @@
 CPPFLAGS = @CPPFLAGS@ $(EXTRA_CPPFLAGS)
 LDFLAGS = @LDFLAGS@ $(EXTRA_LDFLAGS)
 SWIG_LDFLAGS = @SWIG_LDFLAGS@ $(EXTRA_SWIG_LDFLAGS)
+SWIG_CPPFLAGS = @SWIG_CPPFLAGS@ $(EXTRA_CPPFLAGS)

 COMPILE = $(CC) $(CMODEFLAGS) $(CPPFLAGS) $(CMAINTAINERFLAGS) $(CFLAGS) $(INCLUDES)
 COMPILE_NOWARN = $(CC) $(CMODEFLAGS) $(CPPFLAGS) $(CNOWARNFLAGS) $(CFLAGS) $(INCLUDES)
Index: build.conf
===================================================================
--- build.conf	(revision 1535609)
+++ build.conf	(revision 1535610)
@@ -88,9 +88,9 @@

 bdb-test-scripts =

-swig-python-opts = $(CPPFLAGS) -python -classic
-swig-perl-opts = $(CPPFLAGS) -perl -nopm -noproxy
-swig-ruby-opts = $(CPPFLAGS) -ruby
+swig-python-opts = $(SWIG_CPPFLAGS) -python -classic
+swig-perl-opts = $(SWIG_CPPFLAGS) -perl -nopm -noproxy
+swig-ruby-opts = $(SWIG_CPPFLAGS) -ruby
 swig-languages = python perl ruby
 swig-dirs =
         subversion/bindings/swig/python
Index: configure.ac
===================================================================
--- configure.ac	(revision 1535609)
+++ configure.ac	(revision 1535610)
@@ -1490,6 +1490,11 @@
   SVN_STRIP_FLAG(CPPFLAGS, [-no-cpp-precomp ])
 fi

+# Need to strip '-no-cpp-precomp' from CPPFLAGS for SWIG as well.
+SWIG_CPPFLAGS="$CPPFLAGS"
+SVN_STRIP_FLAG(SWIG_CPPFLAGS, [-no-cpp-precomp ])
+AC_SUBST([SWIG_CPPFLAGS])
+
 dnl Since this is used only on Unix-y systems, define the path separator as '/'
 AC_DEFINE_UNQUOTED(SVN_PATH_LOCAL_SEPARATOR, '/',
         [Defined to be the path separator used on your local filesystem])

------------------------------------------------------------------------

Patch 3

diff -u configure.ac configure.ac
--- configure.ac	(working copy)
+++ configure.ac	(working copy)
@@ -1446,6 +1446,10 @@
 # Need to strip '-no-cpp-precomp' from CPPFLAGS for SWIG as well.
 SWIG_CPPFLAGS="$CPPFLAGS"
 SVN_STRIP_FLAG(SWIG_CPPFLAGS, [-no-cpp-precomp ])
+# Swig don't understand "-F" and "-isystem" flags added by Homebrew,
+# so filter them out.
+SVN_STRIP_FLAG(SWIG_CPPFLAGS, [-F\/[[^ ]]* ])
+SVN_STRIP_FLAG(SWIG_CPPFLAGS, [-isystem\/[[^ ]]* ])
 AC_SUBST([SWIG_CPPFLAGS])

 dnl Since this is used only on Unix-y systems, define the path separator as '/'
