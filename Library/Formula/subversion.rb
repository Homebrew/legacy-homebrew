require 'formula'

class Subversion < Formula
  homepage 'http://subversion.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=subversion/subversion-1.8.4.tar.bz2'
  mirror 'http://archive.apache.org/dist/subversion/subversion-1.8.4.tar.bz2'
  sha1 '6e7ac5b56ec22995c763a668c658577f96f2c090'

  bottle do
    revision 1
    sha1 '03a9e38626bf1f9c243b4052a7955985c4962b9f' => :mavericks
    sha1 'c13bbc716a1ee788812ecefd52f36778b22978b9' => :mountain_lion
    sha1 '0d956908378049edfdfcef732af1769b7c52b4c0' => :lion
  end

  option :universal
  option 'with-brewed-openssl', 'Include OpenSSL support to Serf via Homebrew'
  option 'java', 'Build Java bindings'
  option 'perl', 'Build Perl bindings'
  option 'ruby', 'Build Ruby bindings'

  resource 'serf' do
    url 'http://serf.googlecode.com/files/serf-1.3.2.tar.bz2'
    sha1 '90478cd60d4349c07326cb9c5b720438cf9a1b5d'
  end

  depends_on 'pkg-config' => :build

  # Always build against Homebrew versions instead of system versions for consistency.
  depends_on 'sqlite'
  depends_on :python => :optional

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool

  # Bindings require swig
  depends_on 'swig' if build.include? 'perl' or build.include? 'python' or build.include? 'python'

  # For Serf
  depends_on 'scons' => :build
  depends_on 'openssl' if build.with? 'brewed-openssl'

  # If building bindings, allow non-system interpreters
  env :userpaths if build.include? 'perl' or build.include? 'ruby'

  # One patch to prevent '-arch ppc' from being pulled in from Perl's $Config{ccflags},
  # and another one to put the svn-tools directory into libexec instead of bin
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
      system "scons", *args
      system "scons install"
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
      # https://github.com/mxcl/homebrew/issues/20415
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

    # Suggestion by upstream. http://svn.haxx.se/users/archive-2013-09/0188.shtml
    system "./autogen.sh"
    system "./configure", *args
    system "make"
    system "make install"
    bash_completion.install 'tools/client-side/bash_completion' => 'subversion'

    system "make tools"
    system "make install-tools"

    # Swig don't understand "-isystem" flags added by Homebrew, so
    # filter them out from makefiles.
    Dir.glob(buildpath/"**/Makefile*").each do |mkfile|
      inreplace mkfile, /\-isystem[^[:space:]]*/, ''
    end

    python do
      system "make swig-py"
      system "make install-swig-py"
    end

    if build.include? 'perl'
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

    s += python.standard_caveats if python

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

--- Makefile.in~ 2013-07-25 16:55:27.000000000 +0200
+++ Makefile.in 2013-07-25 17:02:02.000000000 +0200
@@ -85,7 +85,7 @@
 swig_pydir_extra = @libdir@/svn-python/svn
 swig_pldir = @libdir@/svn-perl
 swig_rbdir = $(SWIG_RB_SITE_ARCH_DIR)/svn/ext
-toolsdir = @bindir@/svn-tools
+toolsdir = @libexecdir@/svn-tools

 javahl_javadir = @libdir@/svn-javahl
 javahl_javahdir = @libdir@/svn-javahl/include
